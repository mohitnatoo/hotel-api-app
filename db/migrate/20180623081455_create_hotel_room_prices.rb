class CreateHotelRoomPrices < ActiveRecord::Migration[5.2]
  def change
    create_table :hotel_room_prices do |t|
      t.belongs_to :hotel_room, foreign_key: true
      t.date :date, null: false
      t.float :price, null: false, default: 0.0

      t.timestamps
    end

    add_index :hotel_room_prices, :date
    add_index :hotel_room_prices, [:hotel_room_id, :date]
  end
end
