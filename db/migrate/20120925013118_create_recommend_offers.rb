class CreateRecommendOffers < ActiveRecord::Migration
  def change
    create_table :recommend_offers do |t|
      t.references :user
      t.references :offer
      t.text :opinion

      t.timestamps
    end
    add_index :recommend_offers, :user_id
    add_index :recommend_offers, :offer_id
  end
end
