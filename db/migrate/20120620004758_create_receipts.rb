class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.references :user
      t.references :offer
      t.decimal :value, :precision => 8, :scale => 2

      t.timestamps
    end
    add_index :receipts, :user_id
    add_index :receipts, :offer_id
  end
end
