class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, :null => false
      t.text :description
      t.decimal :price, :null => false
      t.boolean :active, :default => 1
      t.references :partner, :null => false
      t.references :product_type, :null => false

      t.timestamps
    end
    add_index :products, :partner_id
    add_index :products, :product_type_id
  end
end
