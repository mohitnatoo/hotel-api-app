class CreateHotels < ActiveRecord::Migration[5.2]
  def change
    create_table :hotels do |t|
      t.string :name, null: false
      t.string :address
      t.string :currency, null:false, default: "USD"

      t.timestamps
    end
  end
end
