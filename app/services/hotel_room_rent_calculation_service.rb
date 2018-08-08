class HotelRoomRentCalculationService

  attr_reader :hotel_room, :start_date, :end_date

  def initialize(hotel_room, start_date: , end_date: )
    @hotel_room = hotel_room
    @start_date = start_date.to_date
    @end_date = end_date.to_date
  end

  def calculate
    price_calculated_per_day.round(2) * average_days_in_a_month
  end

  private

    attr_reader :specified_room_prices

    def price_calculated_per_day
      ( specific_room_prices.sum + default_price_for_days_when_specific_price_not_set ) / number_of_days_of_stay
    end

    def specific_room_prices
      @_specific_room_prices ||= hotel_room.hotel_room_prices.in_date_range(start_date..end_date).pluck(:price)
    end

    def default_price_for_days_when_specific_price_not_set
      days_with_default_price = number_of_days_of_stay - number_of_days_with_specific_price

      days_with_default_price * hotel_room.default_price
    end

    def number_of_days_with_specific_price
      specific_room_prices.count
    end

    def average_days_in_a_month
      # Reason this is not made a constant is to avoid
      # exposing HotelRoomRentCalculationService::DAYS_IN_A_MONTH to the outside.
      # Here encapsulation wins.
      30
    end

    def number_of_days_of_stay
      end_date - start_date + 1 # Inclusive of start and end dates
    end
end