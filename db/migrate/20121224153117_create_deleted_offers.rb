class CreateDeletedOffers < ActiveRecord::Migration
  def change
    add_column :offers, :deleted, :boolean, :default => 0, :null => false
  end
end
