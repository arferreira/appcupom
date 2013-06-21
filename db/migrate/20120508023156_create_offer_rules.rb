class CreateOfferRules < ActiveRecord::Migration
  def change
    create_table :offer_rules do |t|
      t.references :offer
      t.string :description
      t.string :type
      t.integer :value

      t.timestamps
    end
    add_index :offer_rules, :offer_id
  end
end
