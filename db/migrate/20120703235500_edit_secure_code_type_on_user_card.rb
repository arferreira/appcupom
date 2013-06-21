class EditSecureCodeTypeOnUserCard < ActiveRecord::Migration
  def up
    change_column :user_cards, :secure_code, :string
  end

  def down
  end
end
