class RemoveDateFromOfferProduct < ActiveRecord::Migration
  def up
    remove_column :offer_products, :date
      end

  def down
    add_column :offer_products, :date, :date
  end
end
