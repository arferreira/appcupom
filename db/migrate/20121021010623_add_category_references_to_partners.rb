class AddCategoryReferencesToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :category_id, :integer
    add_index :partners, :category_id
  end
end
