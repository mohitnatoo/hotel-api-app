class Room < ApplicationRecord
  belongs_to :hotel_room
  has_many :reservations

  validates_presence_of :hotel_room
  validates_presence_of :room_number
  validates_presence_of :room_number, scope: [:hotel_room]
end
