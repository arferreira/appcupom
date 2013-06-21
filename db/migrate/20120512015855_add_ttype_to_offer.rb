class AddTtypeToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :ttype, :string

  end
end
