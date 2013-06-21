class AddPkToCupons < ActiveRecord::Migration
  def change
    add_column :cupons, :id, :primary_key
  end
end
