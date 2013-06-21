class CreateUserCredits < ActiveRecord::Migration
  def change
    create_table :user_credits do |t|
      t.references :user
      t.string :reason
      t.decimal :value
      t.decimal :current_value
      t.boolean :active

      t.timestamps
    end
    add_index :user_credits, :user_id
  end
end
