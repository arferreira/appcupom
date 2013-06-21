class AddProductTypeInProduct < ActiveRecord::Migration
  def up
    add_column    :products, :product_type_id, :integer
    add_index     :products, :product_type_id
  end

  def down
    remove_column :products, :product_type_id
  end
end
