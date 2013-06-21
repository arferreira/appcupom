class AddAddressInfoInPartners < ActiveRecord::Migration
  def change
    add_column :partners, :add_number, :string
    add_column :partners, :add_complement, :string
    add_column :partners, :add_county, :string
    add_column :partners, :add_state, :string
    add_column :partners, :cep, :string
  end
end
