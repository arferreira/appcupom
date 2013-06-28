class EditDefaultValueOfActiveOnOffers < ActiveRecord::Migration
  def up
    change_column_default(:offers, :active, true)
  end

  def down
  end
end
