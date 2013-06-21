class AddColumnsPartners < ActiveRecord::Migration
  def up
    add_column :partners, :contact_name, :string
    add_column :partners, :has_internet, :boolean
    add_column :partners, :client_age, :string
    add_column :partners, :average_consumption, :string
    add_column :partners, :got_to_know, :string
  end

  def down
  end
end
