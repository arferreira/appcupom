class CreateProductFamilies < ActiveRecord::Migration
  def change
    create_table :product_families do |t|
      t.string :name
      t.references :partner
      t.references :product_type

      t.timestamps
    end
    add_index :product_families, :partner_id
    add_index :product_families, :product_type_id
  end
end
