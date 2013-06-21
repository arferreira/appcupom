class ChangeColunmsLatitudeLongitudePartnersToDecimal < ActiveRecord::Migration
  def up
    change_column :partners, :latitude, :decimal, :precision => 15, :scale => 10
    change_column :partners, :longitude, :decimal, :precision => 15, :scale => 10
  end

  def down
  end
end
