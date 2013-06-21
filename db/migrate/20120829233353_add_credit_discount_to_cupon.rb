class AddCreditDiscountToCupon < ActiveRecord::Migration
  def change
    add_column :cupons, :credit_discount, :decimal

  end
end
