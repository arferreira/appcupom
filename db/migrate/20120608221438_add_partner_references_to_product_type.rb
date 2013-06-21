class AddPartnerReferencesToProductType < ActiveRecord::Migration
  def change
    add_column :product_types, :partner_id, :integer
    add_index :product_types, :partner_id
  end
end
