class RoomAvailabilityService

  attr_reader :hotel_room, :start_date, :end_date

  def initialize(hotel_room, start_date:, end_date:)
    @hotel_room = hotel_room
    @start_date = start_date
    @end_date = end_date
  end

  def fetch
    reserved_room_ids = @hotel_room.reservations.in_date_range(start_date, end_date).pluck(:room_id)
    hotel_room.room_ids - reserved_room_ids
  end

end