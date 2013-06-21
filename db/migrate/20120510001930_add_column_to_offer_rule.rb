class AddColumnToOfferRule < ActiveRecord::Migration
  def change
    add_column :offer_rules, :rule_id, :integer

  end
end
