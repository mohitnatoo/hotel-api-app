require 'test_helper'

class RatesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @hotel = create(:hotel)
    @room_type = create(:room_type)
    @hotel_room = create(:hotel_room, hotel: @hotel, room_type: @room_type)
  end

  test "should return not found in response if hotel not found" do
    patch "/hotels/#{SecureRandom.hex}asdafsd/room_types/#{@room_type.id}/rate", params: { rate: { date: Date.today, price: 100 } }

    assert_response :not_found
  end

  test "should return not found in response if room type is not found" do
    patch "/hotels/#{@hotel.id}/room_types/#{SecureRandom.hex}/rate", params: { rate: { date: Date.today, price: 100 } }

    assert_response :not_found
  end

  test "should return not found in response if hotel and room type are present but hotel does not have that room type" do
    @hotel.hotel_rooms = []

    patch hotel_room_type_rate_url(@hotel, @room_type), params: { rate: { date: Date.today, price: 100 } }

    assert_response :not_found
  end

  test "should return bad request if parameters are missing" do
    patch hotel_room_type_rate_url(@hotel, @room_type), params: { rate: { date: Date.today } }

    assert_response :bad_request
  end

  test "should be able to create a new price for a day if not present already" do
    HotelRoomPrice.destroy_all

    date = Date.today + rand(1..5)
    price = rand(30..60)
    assert_changes -> {@hotel_room.hotel_room_prices.count}, from: 0, to: 1 do
      patch hotel_room_type_rate_url(@hotel, @room_type), params: { rate: { date: date, price: price } }
    end

    assert_response :success

    price_record = @hotel_room.hotel_room_prices.first
    assert_equal price_record.date, date
    assert_equal price_record.price, price

    expected_response = {
      "hotel_room_price_id" => price_record.id,
      "price" => price,
      "date" => date.to_s
    }
    assert_equal expected_response, JSON.parse(response.body)
  end

  test "should be able to update an existing price for a day if present" do
    HotelRoomPrice.destroy_all

    date = Date.today + rand(1..5)
    price = rand(30..60)
    price_record = @hotel_room.hotel_room_prices.create!(date: date, price: rand(1..10))

    assert_no_changes -> {@hotel_room.hotel_room_prices.count} do
      patch hotel_room_type_rate_url(@hotel, @room_type), params: { rate: { date: date, price: price } }
    end

    assert_response :success

    price_record.reload
    assert_equal price_record.date, date
    assert_equal price_record.price, price

    expected_response = {
      "hotel_room_price_id" => price_record.id,
      "price" => price,
      "date" => date.to_s
    }
    assert_equal expected_response, JSON.parse(response.body)
  end

end
