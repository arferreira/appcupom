class AddCodeToCardFlag < ActiveRecord::Migration
  def change
    add_column :card_flags, :code, :string

  end
end
