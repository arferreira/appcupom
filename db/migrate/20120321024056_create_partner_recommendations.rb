class CreatePartnerRecommendations < ActiveRecord::Migration
  def change
    create_table :partner_recommendations, :id => false do |t|
      t.references :partner, :null => false
      t.references :recommendation, :null => false

      t.timestamps
    end
    add_index :partner_recommendations, :partner_id
    add_index :partner_recommendations, :recommendation_id
  end
end