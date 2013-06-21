class AddSaltToAdministrator < ActiveRecord::Migration
  def change
    add_column :administrators, :salt, :string

  end
end
