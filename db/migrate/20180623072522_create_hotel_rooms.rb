class CreateHotelRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :hotel_rooms do |t|
      t.belongs_to :hotel, foreign_key: true
      t.belongs_to :room_type, foreign_key: true
      t.float :default_price, default: 0.0, null: false

      t.timestamps
    end

    add_index :hotel_rooms, :hotel
    add_index :hotel_rooms, :room_type
    add_index :hotel_rooms, [:hotel_id, :room_type_id], unique: true
  end
end
