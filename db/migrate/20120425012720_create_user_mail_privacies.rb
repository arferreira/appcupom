class CreateUserMailPrivacies < ActiveRecord::Migration
  def change
    create_table :user_mail_privacies do |t|
      t.references :user
      t.references :mail_privacy
      t.boolean :choice

      t.timestamps
    end
    add_index :user_mail_privacies, :user_id
    add_index :user_mail_privacies, :mail_privacy_id
  end
end
