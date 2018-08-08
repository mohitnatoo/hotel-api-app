class RateUpdateService

  attr_reader :hotel_room, :options, :result

  def initialize(hotel_room, options)
    @hotel_room = hotel_room
    @options = options
    @result = {}
  end

  def process
    # Find if there is a record present for that particular date, if present we'll update that record,
    #   if not it will get created.
    hotel_room_price = hotel_room.hotel_room_prices.find_or_initialize_by(date: options[:date])
    hotel_room_price.price = options[:price]
    hotel_room_price.save!

    result.merge!({
                    hotel_room_price_id: hotel_room_price.id,
                    price: hotel_room_price.price,
                    date: hotel_room_price.date
                  })
  end

end