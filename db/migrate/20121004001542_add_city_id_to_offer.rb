class AddCityIdToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :city_id, :integer

  end
end
