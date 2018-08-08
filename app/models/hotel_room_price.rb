class HotelRoomPrice < ApplicationRecord
  belongs_to :hotel_room

  validates_presence_of :hotel_room
  validates_presence_of :date
  validates_presence_of :price

  scope :in_date_range, ->(date_range){ where(date: date_range) }
end
