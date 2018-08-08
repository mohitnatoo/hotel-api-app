class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.belongs_to :hotel_room, foreign_key: true
      t.string :room_number, null: false
      t.string :description

      t.timestamps
    end

    add_index :rooms, :hotel_room
  end
end
