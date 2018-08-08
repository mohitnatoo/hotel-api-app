class ReservationsController < ApplicationController
  include HotelRoomConcern
  include DateRangeConcern

  before_action :load_available_rooms

  def create
    if @available_room_ids.empty?
      render status: :unprocessable_entity, json: { error: "No rooms are available in given date range" }
    else
      reservation_service = ReservationService.new(@available_room_ids, params)
      reservation_service.process

      if reservation_service.errors.any?
        render json: { error: reservation_service.errors.join(", ") }, status: :internal_server_error
      else
        render json: reservation_service.result, status: :created
      end
    end
  end

  private

    def load_available_rooms
      @available_room_ids = RoomAvailabilityService.new(@hotel_room,
                                                        start_date: params[:start_date],
                                                        end_date: params[:end_date]).fetch
    end
end
