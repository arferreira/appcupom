class CreateUserPrivacies < ActiveRecord::Migration
  def change
    create_table :user_privacies do |t|
      t.references :user
      t.references :privacy

      t.timestamps
    end
    add_index :user_privacies, :user_id
    add_index :user_privacies, :privacy_id
  end
end
