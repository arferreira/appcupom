class RenameAdminRoleOnAdministrators < ActiveRecord::Migration
  def up
    rename_column :administrators, :Admin_Role_id, :admin_role_id
  end

  def down
  end
end
