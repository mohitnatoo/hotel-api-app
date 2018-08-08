# frozen_string_literal: true

FactoryBot.define do

  factory :user do
    first_name "Sam"
    last_name "Smith"
    email { "#{SecureRandom.alphanumeric}@example.com" }
  end

  factory :hotel do
    name {"Hampton Inn & Suites #{SecureRandom.uuid}"}
    address "Thousand Oaks"
  end

  factory :room_type do
    name "Double bed #{SecureRandom.uuid}"
    occupancy_limit 2
  end

  factory :hotel_room do
    hotel
    room_type
    default_price 50
  end

  factory :room do
    hotel_room
    room_number { SecureRandom.alphanumeric }
    description { SecureRandom.alphanumeric }
  end

  factory :reservation do
    user
    room
    start_date { Date.today }
    end_date { Date.today + 30.days }
    price 30
  end

  factory :hotel_room_price do
    hotel_room
    date { Date.today }
    price { 50 }
  end

  factory :payment_transaction do
    reservation
    source "stripe"
    source_id { SecureRandom.uuid }
  end

end
