module HotelRoomConcern

  extend ActiveSupport::Concern

  included do
    before_action :load_resource
  end

  private

    def load_resource
      @hotel = Hotel.find_by_id(params[:hotel_id])
      raise ActiveRecord::RecordNotFound if @hotel.nil?

      @room_type = RoomType.find_by_id(params[:room_type_id])
      raise ActiveRecord::RecordNotFound if @room_type.nil?

      @hotel_room = @hotel.hotel_rooms.find_by( room_type: @room_type )
      raise ActiveRecord::RecordNotFound if @hotel_room.nil?

      # XXX::
      # Here we can have code for authorization, whether user can access this resource and throw :unauthorized status
      #
      # Using pundit gem we can do something like
      # authorize @hotel_room, :update?
      #
      # Not implementing authorization for now as that would increase the scope
      #
    end

end