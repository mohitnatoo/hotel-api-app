class RatesController < ApplicationController
  include HotelRoomConcern

  def update
    updater = RateUpdateService.new(@hotel_room, rate_params)
    updater.process

    render json: updater.result, status: :ok
  end

  private

    def rate_params
      options = params.require(:rate).permit(:date, :price)

      if options[:date].blank? || options[:price].blank?
        raise ValidationError, "parameters missing"
      end

      options
    end

end
