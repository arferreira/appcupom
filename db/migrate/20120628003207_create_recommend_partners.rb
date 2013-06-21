class CreateRecommendPartners < ActiveRecord::Migration
  def change
    create_table :recommend_partners do |t|
      t.references :user
      t.references :partner
      t.text :opinion

      t.timestamps
    end
    add_index :recommend_partners, :user_id
    add_index :recommend_partners, :partner_id
  end
end
