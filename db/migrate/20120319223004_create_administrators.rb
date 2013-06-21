class CreateAdministrators < ActiveRecord::Migration
  def change
    create_table :administrators do |t|
      t.string :name, :null => false
      t.string :email, :null => false
      t.references :Admin_Role, :null => false

      t.timestamps
    end
    add_index :administrators, :Admin_Role_id
  end
end
