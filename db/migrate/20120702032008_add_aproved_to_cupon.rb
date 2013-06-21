class AddAprovedToCupon < ActiveRecord::Migration
  def change
    add_column :cupons, :approved, :boolean

  end
end
