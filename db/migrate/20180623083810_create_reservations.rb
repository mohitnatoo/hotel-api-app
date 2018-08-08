class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.belongs_to :room, foreign_key: true, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.float :price, null: false

      t.timestamps
    end

    add_index :reservations, :user
    add_index :reservations, :start_date
    add_index :reservations, :end_date
  end
end
