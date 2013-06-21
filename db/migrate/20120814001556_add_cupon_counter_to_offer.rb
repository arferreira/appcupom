class AddCuponCounterToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :cupon_counter, :int

  end
end
