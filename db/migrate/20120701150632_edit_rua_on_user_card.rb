class EditRuaOnUserCard < ActiveRecord::Migration
  def up
    rename_column :user_cards, :rua, :logradouro
  end

  def down
    rename_column :user_cards,  :logradouro, :rua
  end
end
