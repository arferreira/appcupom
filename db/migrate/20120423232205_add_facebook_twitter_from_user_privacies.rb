class AddFacebookTwitterFromUserPrivacies < ActiveRecord::Migration
  def up
    add_column :user_privacies, :twitter, :boolean
    add_column :user_privacies, :facebook, :boolean
  end

  def down
  end
end
