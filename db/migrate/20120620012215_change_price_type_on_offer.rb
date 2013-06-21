class ChangePriceTypeOnOffer < ActiveRecord::Migration
  def up
    change_column :offers, :price, :decimal, :precision => 8, :scale => 2
    change_column :cupons, :price, :decimal, :precision => 8, :scale => 2
  end

  def down
  end
end
