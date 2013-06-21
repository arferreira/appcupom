class CreateMonthlyCuponAccountings < ActiveRecord::Migration
  def change
    create_table :monthly_cupon_accountings do |t|
      t.string :month_accounting, :null => false
      t.decimal :total_value, :null => false
      t.integer :total_sold, :null => false

      t.timestamps
    end
  end
end
