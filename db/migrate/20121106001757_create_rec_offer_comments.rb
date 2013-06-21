class CreateRecOfferComments < ActiveRecord::Migration
  def change
    create_table :rec_offer_comments do |t|
      t.integer :id
      t.integer :user_id
      t.integer :recommend_offer_id
      t.text :opinion

      t.timestamps
    end
  end
end
