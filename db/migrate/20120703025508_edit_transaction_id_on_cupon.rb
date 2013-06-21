class EditTransactionIdOnCupon < ActiveRecord::Migration
  def up
    change_column :cupons, :transaction_id, :string
  end

  def down
  end
end
