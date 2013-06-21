class AddSystemProfitToPartner < ActiveRecord::Migration
  def change
    add_column :partners, :system_profit, :integer
  end
end
