class AddProductQtyToOfferProduct < ActiveRecord::Migration
  def change
    add_column :offer_products, :product_qty, :integer

  end
end
