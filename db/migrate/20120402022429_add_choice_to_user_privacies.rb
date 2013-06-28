class AddChoiceToUserPrivacies < ActiveRecord::Migration
  def change
    add_column :user_privacies, :choice, :boolean, :default => false, :null => false
  end
end
