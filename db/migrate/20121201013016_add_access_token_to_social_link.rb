class AddAccessTokenToSocialLink < ActiveRecord::Migration
  def change
    add_column :social_links, :access_token, :string

  end
end
