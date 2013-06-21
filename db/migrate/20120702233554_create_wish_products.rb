class CreateWishProducts < ActiveRecord::Migration
  def change
    create_table :wish_products do |t|
      t.references :user
      t.references :product
      t.text :opinion

      t.timestamps
    end
    add_index :wish_products, :user_id
    add_index :wish_products, :product_id
  end
end
