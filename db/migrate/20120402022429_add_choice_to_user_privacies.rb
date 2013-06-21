class AddChoiceToUserPrivacies < ActiveRecord::Migration
  def change
    add_column :user_privacies, :choice, :boolean, :default => 0, :null => false
  end
end
