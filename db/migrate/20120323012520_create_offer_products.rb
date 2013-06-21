class CreateOfferProducts < ActiveRecord::Migration
  def change
    create_table :offer_products, :id => false do |t|
      t.references :product, :null => false
      t.references :offer, :null => false
      t.date :date, :null => false

      t.timestamps
    end
    add_index :offer_products, :product_id
    add_index :offer_products, :offer_id
  end
end
