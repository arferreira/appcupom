class AddEncryptedPasswordToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :encrypted_password, :string
    add_column :partners, :salt, :string
  end
end
