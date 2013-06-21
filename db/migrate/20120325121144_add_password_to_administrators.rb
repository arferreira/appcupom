class AddPasswordToAdministrators < ActiveRecord::Migration
  def change
    add_column :administrators, :encrypted_password, :string

  end
end
