class CreateUserCards < ActiveRecord::Migration
  def change
    create_table :user_cards do |t|
      t.references :user
      t.references :card_flag
      t.integer :secure_code
      t.string :rua
      t.string :numero
      t.string :complemento
      t.string :bairro
      t.string :cidade
      t.string :estado
      t.string :cep
      t.string :telefone
      t.string :key

      t.timestamps
    end
    add_index :user_cards, :user_id
    add_index :user_cards, :card_flag_id
  end
end
