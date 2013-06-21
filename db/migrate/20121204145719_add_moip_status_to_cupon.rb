class AddMoipStatusToCupon < ActiveRecord::Migration
  def change
    add_column :cupons, :moip_status, :string

  end
end
