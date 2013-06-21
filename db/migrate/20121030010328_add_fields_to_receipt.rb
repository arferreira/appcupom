class AddFieldsToReceipt < ActiveRecord::Migration
  def change
    add_column :receipts, :partner_id, :integer

    add_column :receipts, :description, :string

    add_column :receipts, :nowon_price, :decimal, :precision => 8, :scale => 2

    add_column :receipts, :partner_price, :decimal, :precision => 8, :scale => 2

    add_column :receipts, :credit, :decimal, :precision => 8, :scale => 2

    add_column :receipts, :discount, :integer

    add_column :receipts, :migrated, :boolean

  end
end
