# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

HOTELS_AND_ROOMS = [
  {
    name: "Miyako Hotel",
    address: "Los Angeles",
    room_types: [
      {
        name: "2 full­size beds with a private bath",
        occupancy_limit: 4,
        rooms: [
          {
            room_number: "101",
            description: "Room with beach view"
          },
          {
            room_number: "102",
            description: "Room with city view"
          },
          {
            room_number: "901",
            description: "Room on top floor"
          }
        ],
        default_price: 35
      },
      {
        name: "King­size bed with a private bath",
        occupancy_limit: 2,
        rooms: [
          {
            room_number: "201",
            description: "very spacious room"
          },
          {
            room_number: "208",
            description: "corner room"
          }
        ],
        default_price: 40
      }
    ]
  },
  {
    name: "Hampton Inn & Suites",
    address: "Thousand Oaks",
    room_types: [
      {
        name: "2 Queen­size beds with a private bath",
        occupancy_limit: 4,
        rooms: [
          {
            room_number: "qb101",
            description: "very spacious room"
          },
          {
            room_number: "qb102",
            description: "corner room"
          },
          {
            room_number: "qb503",
            description: "huge room"
          }
        ],
        default_price: 50
      },
      {
        name: "King­size bed with a private bath",
        occupancy_limit: 2,
        rooms: [
          {
            room_number: "kb101",
            description: "very spacious room"
          },
          {
            room_number: "kb202",
            description: "corner room"
          }
        ],
        default_price: 45
      }
    ]
  }
]

def create_user
  User.create!(email: "sam@example.com", first_name: "Sam", last_name: "Smith")
end

def populate_rooms_for_hotel(hotel, room_data)
  room_type = RoomType.find_or_create_by!(name: room_data[:name], occupancy_limit: room_data[:occupancy_limit])
  hotel_room = hotel.hotel_rooms.create!(room_type: room_type)

  room_data[:rooms].each do |room_attributes|
    hotel_room.rooms.create!(room_attributes)
  end
end

def create_hotels_and_rooms
  HOTELS_AND_ROOMS.each do |hotel_data|
    name, address, room_types = hotel_data[:name], hotel_data[:address], hotel_data[:room_types]
    hotel = Hotel.create!(name: name, address: address)

    room_types.each do |room_data|
      populate_rooms_for_hotel(hotel, room_data)
    end
  end
end

create_user
create_hotels_and_rooms
