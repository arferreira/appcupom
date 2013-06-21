class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :company_name,     :null => false
      t.string :trade_name,     :null => false
      t.string :site
      t.string :email,     :null => false
      t.string :primary_phone,     :null => false
      t.string :secondary_phone
      t.string :facebook_link
      t.string :twitter_link
      t.integer :cnpj,     :null => false
      t.text :description
      t.date :foundation
      t.integer :latitude,     :null => false
      t.integer :longitude,     :null => false
      t.integer :capacity,     :null => false
      t.boolean :active,     :default => 1
      t.boolean :approved,     :default => false
      t.references :administrator
      t.references :category, :null => false

      t.timestamps
    end
    add_index :partners, :administrator_id
    add_index :partners, :category_id
  end
end
