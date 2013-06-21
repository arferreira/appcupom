class AddCityToPartner < ActiveRecord::Migration
  def change
    add_column :partners, :city_id, :integer

  end
end
