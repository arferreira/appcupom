class AddMoipIdToCupon < ActiveRecord::Migration
  def change
    add_column :cupons, :moip_id, :string

  end
end
