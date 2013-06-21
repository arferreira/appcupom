class AddSaveCardToUserCard < ActiveRecord::Migration
  def change
    add_column :user_cards, :save_card, :boolean

  end
end
