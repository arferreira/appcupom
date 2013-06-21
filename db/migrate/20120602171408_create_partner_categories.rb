class CreatePartnerCategories < ActiveRecord::Migration
  def self.up
    create_table :partner_categories, :id => false do |t|
      t.references :partner
      t.references :category
    end
    add_index :partner_categories, [:partner_id, :category_id]
    add_index :partner_categories, [:category_id, :partner_id]
  end

  def self.down
    drop_table :partner_categories
  end
end