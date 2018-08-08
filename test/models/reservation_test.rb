require 'test_helper'

class ReservationTest < ActiveSupport::TestCase

  test "in_date_range when start is in the past and end is in the range" do
    reservation = create(:reservation, start_date: Date.today - 5.days, end_date: Date.today + 5.days)

    assert_includes Reservation.in_date_range(Date.today, Date.today+10.days), reservation
  end

  test "in_date_range when start is in the past and end is in the past" do
    reservation = create(:reservation, start_date: Date.today - 5.days, end_date: Date.today - 2.days)

    assert_not_includes Reservation.in_date_range(Date.today, Date.today+10.days), reservation
  end

  test "in_date_range when start is in the range and end is in future" do
    reservation = create(:reservation, start_date: Date.today + 5.days, end_date: Date.today + 20.days)

    assert_includes Reservation.in_date_range(Date.today, Date.today+10.days), reservation
  end

  test "in_date_range when start is in the range and end is in the range" do
    reservation = create(:reservation, start_date: Date.today + 3.days, end_date: Date.today + 8.days)

    assert_includes Reservation.in_date_range(Date.today, Date.today+10.days), reservation
  end

  test "in_date_range when start and end are in future" do
    reservation = create(:reservation, start_date: Date.today + 15.days, end_date: Date.today + 25.days)

    assert_not_includes Reservation.in_date_range(Date.today, Date.today+10.days), reservation
  end

end
