class CreateAdminRoles < ActiveRecord::Migration
  def change
    create_table :admin_roles do |t|
      t.string :name,   :null => false
      t.text :description

      t.timestamps
    end
  end
end
