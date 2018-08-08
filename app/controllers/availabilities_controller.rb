class AvailabilitiesController < ApplicationController
  include HotelRoomConcern
  include DateRangeConcern

  def show
    availability_service = HotelRoomAvailabilityAndPriceService.new(@hotel_room,
                                                                    start_date: params[:start_date],
                                                                    end_date: params[:end_date])
    availability_service.process

    render json: availability_service.result, status: :ok
  end
end
