class AddTransactionIdToCupon < ActiveRecord::Migration
  def change
    add_column :cupons, :transaction_id, :integer

  end
end
