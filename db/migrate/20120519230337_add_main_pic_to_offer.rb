class AddMainPicToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :main_pic, :integer

  end
end
