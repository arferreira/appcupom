class AddValidatedCupon < ActiveRecord::Migration
  def change
    add_column :cupons, :validated, :boolean
    add_column :cupons, :validated_date, :datetime
  end
end
