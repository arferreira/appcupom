class AddBillValueToCupon < ActiveRecord::Migration
  def change
    add_column :cupons, :bill_value, :decimal, :precision => 8, :scale => 2

  end
end
