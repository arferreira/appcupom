class AddFacebookFriendToFriendship < ActiveRecord::Migration
  def change
    add_column :friendships, :facebook_friend, :boolean

  end
end
