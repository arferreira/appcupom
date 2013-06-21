class RemoveFacebookTwitterFromUserPrivacies < ActiveRecord::Migration
  def up
    remove_column :user_privacies, :twitter

    remove_column :user_privacies, :facebook
  end

  def down
  end
end
