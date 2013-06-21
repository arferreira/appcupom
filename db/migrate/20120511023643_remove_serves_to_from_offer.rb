class RemoveServesToFromOffer < ActiveRecord::Migration
  def up
    remove_column :offers, :serves_to
      end

  def down
    add_column :offers, :serves_to, :integer
  end
end
