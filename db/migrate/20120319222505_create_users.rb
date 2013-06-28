class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name,      :limit => 45, :null => false
      t.string :email,     :null => false
      t.date :dob
      t.string :gender
      t.boolean :active,  :default => true

      t.timestamps
    end
  end
end
