class CreatePrivacies < ActiveRecord::Migration
  def change
    create_table :privacies do |t|
      t.string :Description
      t.boolean :Default

      t.timestamps
    end
  end
end
