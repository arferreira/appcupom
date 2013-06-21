class AddAddressToPartner < ActiveRecord::Migration
  def change
    add_column :partners, :address, :string

  end
end
