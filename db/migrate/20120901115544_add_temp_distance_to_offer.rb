class AddTempDistanceToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :temp_distance, :string

  end
end
