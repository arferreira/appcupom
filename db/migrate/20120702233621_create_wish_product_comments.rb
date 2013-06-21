class CreateWishProductComments < ActiveRecord::Migration
  def change
    create_table :wish_product_comments do |t|
      t.references :user
      t.references :wish_product
      t.text :opinion

      t.timestamps
    end
    add_index :wish_product_comments, :user_id
    add_index :wish_product_comments, :wish_product_id
  end
end
