class AddCardNumberToUserCard < ActiveRecord::Migration
  def change
    add_column :user_cards, :card_number, :string

  end
end
