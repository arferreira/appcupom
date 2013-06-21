class AddOriginalPriceToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :original_price, :decimal, :precision => 8, :scale => 2

  end
end
