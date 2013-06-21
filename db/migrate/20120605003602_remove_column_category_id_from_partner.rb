class RemoveColumnCategoryIdFromPartner < ActiveRecord::Migration
  def up
    remove_column :partners, :category_id
  end

  def down
    add_column :partners, :category_id, :references
  end
end