class Hotel < ApplicationRecord
  has_many :hotel_rooms
  has_many :room_types, through: :hotel_rooms, source: :room_type
  has_many :rooms, through: :hotel_rooms

  validates_presence_of :name
end
