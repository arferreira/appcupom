class CreateSubCategories < ActiveRecord::Migration
  def change
    create_table :sub_categories do |t|
      t.string :name
      t.references :category

      t.timestamps
    end
    add_index :sub_categories, :category_id
    add_column :partners, :sub_category_id, :integer
    add_index :partners, :sub_category_id
  end
end
