class AddPausedToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :paused, :boolean

  end
end
