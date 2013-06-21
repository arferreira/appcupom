class AddColumnPublicProductTypes < ActiveRecord::Migration
  def up
    add_column :product_types, :public, :boolean
  end

  def down
    remove_column :product_types, :public
  end
end
