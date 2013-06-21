class AddActiveToProductType < ActiveRecord::Migration
  def change
    add_column :product_types, :active, :boolean, :default => true

  end
end
