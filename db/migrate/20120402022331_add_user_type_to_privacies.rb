class AddUserTypeToPrivacies < ActiveRecord::Migration
  def change
    add_column :privacies, :user_type, :string, :limit => 2
  end 
end
