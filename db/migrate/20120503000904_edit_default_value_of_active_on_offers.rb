class EditDefaultValueOfActiveOnOffers < ActiveRecord::Migration
  def up
    change_column_default(:offers, :active, 1)
  end

  def down
  end
end
