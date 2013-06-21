class AddIdToOfferProduct < ActiveRecord::Migration
  def change
    add_column :offer_products, :id, :primary_key

  end
end
