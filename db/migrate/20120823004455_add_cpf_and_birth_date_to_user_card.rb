class AddCpfAndBirthDateToUserCard < ActiveRecord::Migration
  def change
    add_column :user_cards, :cpf, :string

    add_column :user_cards, :birthdate, :string

  end
end
