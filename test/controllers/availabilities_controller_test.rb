require 'test_helper'

class AvailabilitiesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @hotel = create(:hotel, currency: ["USD", "GBP", "EUR"].sample)
    @single_room = create(:room_type, name: "single room", occupancy_limit: 1)
    @double_room = create(:room_type, name: "double room", occupancy_limit: 2)
  end

  test "should return not found in response if hotel not found" do
    create(:hotel_room, hotel: @hotel, room_type: @double_room)
    get "/hotels/#{SecureRandom.uuid}/room_types/#{@double_room.id}/availability", params: { start_date: Date.today,
                                                                                                   end_date: Date.today + 1.month }

    assert_response :not_found
  end

  test "should return not found in response if room type is not found" do
    create(:hotel_room, hotel: @hotel, room_type: @double_room)
    get "/hotels/#{@hotel.id}/room_types/#{SecureRandom.uuid}/availability", params: { start_date: Date.today,
                                                                                      end_date: Date.today + 1.month }

    assert_response :not_found
  end

  test "should return not found in response if hotel and room type are present but hotel does not have that room type" do
    @hotel.hotel_rooms = []

    get hotel_room_type_availability_url(@hotel, @single_room), params: { start_date: Date.today,
                                                                          end_date: Date.today + 1.month }

    assert_response :not_found
  end

  test "api response when there is no room available" do
    @hotel_room = create(:hotel_room, hotel: @hotel, room_type: @double_room)
    create_rooms_and_reserve_all_of_them

    start_date, end_date = Date.today, Date.today + 1.month

    get hotel_room_type_availability_url(@hotel, @single_room), params: { start_date: start_date, end_date: end_date }

    assert_response :success
    assert_equal JSON.parse(response.body), { "start_date" => start_date.to_s, "end_date" => end_date.to_s, "available" => false }
  end

  test "api response when room is available" do
    @hotel_room = create(:hotel_room, hotel: @hotel, room_type: @double_room)

    days_of_stay = rand(30..40)
    days_to_set_specific_price = rand(5..10)
    price_for_specified_days = rand(6..10) * 10

    create_pricing_for_hotel_room(days_to_set_specific_price, price_for_specified_days)

    no_of_rooms = rand(5..8)
    no_of_rooms_reserved = rand(1..4)
    create_rooms_and_reserve(no_of_rooms, no_of_rooms_reserved)

    start_date = Date.today
    end_date = Date.today + days_of_stay - 1
    get hotel_room_type_availability_url(@hotel, @double_room), params: { start_date: start_date, end_date: end_date }

    assert_response :success
    response_body = JSON.parse(response.body)

    expected_response = {
      "start_date" => start_date.to_s,
      "end_date" => end_date.to_s,
      "available" => true,
      "currency" => @hotel_room.currency,
      "available_count" => no_of_rooms - no_of_rooms_reserved,
      "rent" => calculate_price(days_of_stay, days_to_set_specific_price, price_for_specified_days)
    }

    assert_equal expected_response, response_body
  end

  private

    def create_rooms_and_reserve_all_of_them
      @hotel_room = @hotel.hotel_rooms.create!(room_type: @single_room)
      rand(1..3).times do
        room = create(:room, hotel_room: @hotel_room)
        # reservation start date is in the past but end date is within a month
        create(:reservation, room: room, start_date: Date.today - rand(1..5), end_date: Date.today + rand(10..25))

        another_room = create(:room, hotel_room: @hotel_room)
        # reservation date is within a month in future
        create(:reservation, room: another_room, start_date: Date.today + rand(15..20), end_date: Date.today + rand(35..40))
      end
    end

    def create_pricing_for_hotel_room(number_of_days, price)
      start_date = Date.today + 1
      end_date = Date.today + number_of_days
      (start_date..end_date).each do |date|
        create(:hotel_room_price, hotel_room: @hotel_room, date: date, price: price)
      end
    end

    def create_rooms_and_reserve(no_of_rooms, no_of_rooms_reserved)
      no_of_rooms.times do
        create(:room, hotel_room: @hotel_room)
      end

      @hotel_room.rooms.first(no_of_rooms_reserved).each do |room|
        create(:reservation, room: room)
      end
    end

    def calculate_price(days_of_stay, days_to_set_specific_price, price_for_specified_days)
      days_with_default_price = days_of_stay - days_to_set_specific_price
      total_price = (days_to_set_specific_price * price_for_specified_days) + (days_with_default_price * @hotel_room.default_price)
      price_per_day = (total_price/days_of_stay).round(2)

      price_per_day*30
    end

end
