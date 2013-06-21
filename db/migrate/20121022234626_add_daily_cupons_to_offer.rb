class AddDailyCuponsToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :daily_cupons, :integer

  end
end
