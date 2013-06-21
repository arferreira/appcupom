class AddNameToUserCard < ActiveRecord::Migration
  def change
    add_column :user_cards, :name, :string

  end
end
