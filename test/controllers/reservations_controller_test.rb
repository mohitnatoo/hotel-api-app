require 'test_helper'

class ReservationsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @hotel = create(:hotel)
    @room_type = create(:room_type)
    @hotel_room = create(:hotel_room, hotel: @hotel, room_type: @room_type)
    @room = create(:room, hotel_room: @hotel_room)

    @start_date = Date.today + rand(1..5)
    @end_date = @start_date + rand(30..35)
    @price = rand(30..50)
    @user = create(:user)
    @currency = %w(USD EUR AUD GBP).sample

    build_params
  end

  test "returns unprocessable entity if no available rooms are present" do
    create(:reservation, room: @room, start_date: Date.today + 10, end_date: Date.today + 40)

    post hotel_room_type_reservations_url(@hotel, @room_type), params: @params

    assert_response :unprocessable_entity
  end

  test "returns bad request when any parameter is missing" do
    post hotel_room_type_reservations_url(@hotel, @room_type), params: @params.except(@params.keys.sample)

    assert_response :bad_request
  end

  test "returns internal server error when response if any errors occurred while creating reservation" do
    ReservationService.any_instance.stubs(:create_stripe_charge).raises(Stripe::CardError, "Card Error")

    post hotel_room_type_reservations_url(@hotel, @room_type), params: @params

    assert_response :internal_server_error
    response_body = JSON.parse(response.body)

    assert_equal response_body,{"error" => "We are unable to process your payment"}
  end

  test "should create reservation and payment transaction" do
    TestCharge = Struct.new(:id)
    @test_charge_id = SecureRandom.uuid

    ReservationService.any_instance.stubs(:charge).returns(TestCharge.new(@test_charge_id))
    ReservationService.any_instance.stubs(:payment_successful?).returns(true)

    assert_difference -> { @room.reservations.count } do
      assert_difference -> { PaymentTransaction.count } do
        post hotel_room_type_reservations_url(@hotel, @room_type), params: @params
      end
    end

    reservation = @room.reservations.order(:created_at).last
    payment_transaction = reservation.payment_transactions.first!

    assert_response :success
    response_body = JSON.parse(response.body)

    expected_response = {
      "reservation_id" => reservation.id,
      "transaction_id" => payment_transaction.id,
      "stripe_charge_id" => @test_charge_id
    }

    assert_equal expected_response, response_body
  end

  private

    def build_params
      @params = {
        start_date: @start_date,
        end_date: @end_date,
        source: SecureRandom.hex,
        price: @price,
        currency: @currency,
        user_id: @user.id
      }
    end

end
