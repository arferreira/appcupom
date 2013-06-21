class ChangePriceTypeOnOffers < ActiveRecord::Migration
  def up
    change_table :offers do |t|
      t.change :price, :decimal
    end
  end

  def down
  end
end
