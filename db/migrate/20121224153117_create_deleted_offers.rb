class CreateDeletedOffers < ActiveRecord::Migration
  def change
    add_column :offers, :deleted, :boolean, :default => false, :null => false
  end
end
