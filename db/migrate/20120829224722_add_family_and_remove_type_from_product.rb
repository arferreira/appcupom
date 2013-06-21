class AddFamilyAndRemoveTypeFromProduct < ActiveRecord::Migration
  def self.up
    add_column    :products, :product_family_id, :integer
    add_index     :products, :product_family_id
    remove_column :products, :product_type_id
  end

  def self.down
    remove_column :products, :product_family_id
    add_column    :products, :product_type_id, :integer
    add_index     :products, :product_type_id
  end
end
