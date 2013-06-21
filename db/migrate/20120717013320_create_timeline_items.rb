class CreateTimelineItems < ActiveRecord::Migration
  def change
    create_table :timeline_items do |t|
      t.references :user
      t.string :item_type
      t.integer :item_count
      t.references :recommend_comment
      t.references :recommend_partner
      t.references :recommend_product
      t.references :wish_product
      t.references :wish_product_comment
      t.references :offer
      t.references :product

      t.timestamps
    end
    add_index :timeline_items, :user_id
    add_index :timeline_items, :recommend_comment_id
    add_index :timeline_items, :recommend_partner_id
    add_index :timeline_items, :recommend_product_id
    add_index :timeline_items, :wish_product_id
    add_index :timeline_items, :wish_product_comment_id
    add_index :timeline_items, :offer_id
    add_index :timeline_items, :product_id
  end
end
