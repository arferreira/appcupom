class RemoveFieldsFromCupon < ActiveRecord::Migration
  def up
    remove_column :cupons, :recurrence
    remove_column :cupons, :validity
    add_column :cupons, :good_date, :date
    
  end

  def down
    add_column :cupons, :validity, :string
    add_column :cupons, :recurrence, :string
  end
end
