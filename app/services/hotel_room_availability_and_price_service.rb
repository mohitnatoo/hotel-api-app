class HotelRoomAvailabilityAndPriceService

  attr_reader :hotel_room, :start_date, :end_date, :result

  def initialize(hotel_room, start_date: , end_date: )
    @hotel_room = hotel_room
    @start_date = start_date
    @end_date = end_date
    @result = { start_date: start_date, end_date: end_date }
  end

  def process
    if available_rooms.empty?
      result.merge!({ available: false })
    else
      result.merge!({ available: true, available_count: available_rooms.count, currency: @hotel_room.currency })
      calculate_rent
    end
  end

  private

    def available_rooms
      @_available_rooms ||= RoomAvailabilityService.new(hotel_room, start_date: start_date, end_date: end_date).fetch
    end

    def calculate_rent
      rent = HotelRoomRentCalculationService.new(@hotel_room, start_date: start_date, end_date: end_date).calculate

      result.merge!({ rent: rent })
    end
end