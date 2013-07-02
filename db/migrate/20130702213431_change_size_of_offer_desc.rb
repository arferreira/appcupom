class ChangeSizeOfOfferDesc < ActiveRecord::Migration
  def change
  	change_column :offers, :description, :text, :limit => 4294967295
  end
end
