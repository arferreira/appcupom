class RemoveUsersNameLengthLimit < ActiveRecord::Migration
  def up
  	change_column :users, :name, :string, :limit => nil
  end

  def down
  	change_column :users, :name, :string, :limit => 45
  end
end
