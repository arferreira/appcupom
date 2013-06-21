class AddTempDistanceToPartner < ActiveRecord::Migration
  def change
    add_column :partners, :temp_distance, :string

  end
end
