class CreateOfferComments < ActiveRecord::Migration
  def change
    create_table :offer_comments, :id => false do |t|
      t.references :offer, :null => false
      t.references :user, :null => false
      t.text :comment, :null => false
      t.boolean :approved

      t.timestamps
    end
    add_index :offer_comments, :offer_id
    add_index :offer_comments, :user_id
  end
end
