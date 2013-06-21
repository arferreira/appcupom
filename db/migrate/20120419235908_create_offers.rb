class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.references :partner
      t.string :description
      t.integer :discount
      t.decimal :price
      t.time :time_starts
      t.time :time_ends
      t.string :recurrence
      t.boolean :active
      t.integer :serves_to

      t.timestamps
    end
    add_index :offers, :partner_id
  end
end
