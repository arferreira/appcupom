class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :description
      t.string :offer_type
      t.string :ttype
      t.string :default

      t.timestamps
    end
  end
end
