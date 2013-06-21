class CreateMailPrivacies < ActiveRecord::Migration
  def change
    create_table :mail_privacies do |t|
      t.string :description
      t.boolean :defaul
      t.string :user_type

      t.timestamps
    end
  end
end
