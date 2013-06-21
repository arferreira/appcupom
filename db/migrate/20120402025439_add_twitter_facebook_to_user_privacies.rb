class AddTwitterFacebookToUserPrivacies < ActiveRecord::Migration
  def change
    rename_column :user_privacies, :choice, :nowon
    
    add_column :user_privacies, :twitter, :string

    add_column :user_privacies, :facebook, :string

  end
end
