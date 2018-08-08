class HotelRoom < ApplicationRecord
  belongs_to :hotel
  belongs_to :room_type
  has_many :hotel_room_prices
  has_many :rooms
  has_many :reservations, through: :rooms

  validates_presence_of :hotel
  validates_presence_of :room_type
  validates_uniqueness_of :room_type_id, scope: [:hotel_id]

  delegate :currency, to: :hotel
end
