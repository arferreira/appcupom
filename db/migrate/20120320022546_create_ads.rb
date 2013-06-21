class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :name, :null => false
      t.date :date_starts, :null => false
      t.date :date_ends, :null => false
      t.references :client, :null => false

      t.timestamps
    end
    add_index :ads, :client_id
  end
end
