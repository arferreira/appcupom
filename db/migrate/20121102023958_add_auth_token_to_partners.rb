class AddAuthTokenToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :auth_token, :string

  end
end
