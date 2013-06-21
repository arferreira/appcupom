class AddNaspKeyToCupon < ActiveRecord::Migration
  def change
    add_column :cupons, :nasp_key, :string

  end
end
