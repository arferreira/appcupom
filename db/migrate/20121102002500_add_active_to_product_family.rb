class AddActiveToProductFamily < ActiveRecord::Migration
  def change
    add_column :product_families, :active, :boolean, :default => true

  end
end
