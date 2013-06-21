class CreateSocialLinks < ActiveRecord::Migration
  def change
    create_table :social_links, :id => false do |t|
      t.string :username
      t.string :social_id, :null => false
      t.string :social_type, :null => false
      t.string :image_url
      t.string :access_toke_secret
      t.references :user, :null => false

      t.timestamps
    end
    add_index :social_links, :user_id
  end
end
