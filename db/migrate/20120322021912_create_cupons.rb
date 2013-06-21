class CreateCupons < ActiveRecord::Migration
  def change
    create_table :cupons, :id => false do |t|
      t.references :user, :null => false
      t.references :offer, :null => false
      t.integer :recurrence, :null => false
      t.datetime :validity, :null => false
      t.decimal :price, :null => false
      t.string :cupon_code, :null => false
      t.references :monthly_cupon_accounting, :null => false

      t.timestamps
    end
    add_index :cupons, :user_id
    add_index :cupons, :offer_id
    add_index :cupons, :recurrence
    add_index :cupons, :monthly_cupon_accounting_id
  end
end
