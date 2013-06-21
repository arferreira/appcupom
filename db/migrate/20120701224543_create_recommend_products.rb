class CreateRecommendProducts < ActiveRecord::Migration
  def change
    create_table :recommend_products do |t|
      t.references :user
      t.references :product
      t.text :opinion

      t.timestamps
    end
    add_index :recommend_products, :user_id
    add_index :recommend_products, :product_id
  end
end
