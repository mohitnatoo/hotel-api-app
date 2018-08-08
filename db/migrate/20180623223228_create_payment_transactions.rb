class CreatePaymentTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_transactions do |t|
      t.belongs_to :reservation, foreign_key: true
      t.string :source, null: false, default: "stripe"
      t.string :source_id

      t.timestamps
    end
  end
end
