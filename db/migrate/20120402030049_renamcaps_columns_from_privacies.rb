class RenamcapsColumnsFromPrivacies < ActiveRecord::Migration
  def up
    rename_column :privacies, :Description, :description
    rename_column :privacies, :Default, :default
  end

  def down
  end
end
