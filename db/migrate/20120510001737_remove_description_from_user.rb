class RemoveDescriptionFromUser < ActiveRecord::Migration
  def up
      remove_column :offer_rules, :description
      remove_column :offer_rules, :type
  end

  def down
    add_column :offer_rules, :type, :string
    add_column :offer_rules, :description, :string
  end
end
