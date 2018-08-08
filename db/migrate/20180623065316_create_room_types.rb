class CreateRoomTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :room_types do |t|
      t.string :name, null: false
      t.integer :occupancy_limit, null: false

      t.timestamps
    end

    add_index :room_types, :occupancy_limit
    add_index :room_types, [:name, :occupancy_limit], unique: true
  end
end
