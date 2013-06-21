class AddIconToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :icon, :string
  end
end
