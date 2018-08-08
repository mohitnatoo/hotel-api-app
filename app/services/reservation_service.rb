class ReservationService

  attr_reader :room, :options, :result, :errors

  def initialize(available_room_ids, options)
    @options = options
    @result = {}
    @errors = []
    @room = Room.where(id: available_room_ids).first!

    raise ValidationError if mandatory_options_missing?
  end

  def process
    if payment_successful?
      Reservation.transaction do
        result.merge!({stripe_charge_id: charge.id})
        save_reservation!
        save_payment_transaction!
      end
    end
  end

  private

    attr_reader :charge

    def mandatory_options_missing?
      %i[price currency user_id source].any? { |key| options[key].blank? }
    end

    def payment_successful?
      process_with_error_handling do
        create_stripe_charge
      end

      charge.present?
    end

    def create_stripe_charge
      # This is done considering the scope is to just create a charge.
      # Options like saving payment mode, recurring payments etc., are not handled.
      #
      @charge = Stripe::Charge.create(
        amount:   options[:price],
        currency: options[:currency],
        source:   options[:source]
      )
    end

    def process_with_error_handling
      begin
        yield
      rescue Stripe::CardError, Stripe::InvalidRequestError => ex
        errors << ex.message
      rescue Exception => ex
        errors << "We are unable to process your payment"
      end
    end

    def save_reservation!
      @reservation = room.reservations.create!( user_id:     options[:user_id],
                                                start_date:  options[:start_date],
                                                end_date:    options[:end_date],
                                                price:       options[:price])

      result.merge!({ reservation_id: @reservation.id })
    end

    def save_payment_transaction!
      payment_transaction = @reservation.payment_transactions.create!(source: "stripe", source_id: charge.id)

      result.merge!({ transaction_id: payment_transaction.id })
    end

end