class AlterDefauOnMailPrivacies < ActiveRecord::Migration
  def up
     rename_column :mail_privacies, :defaul, :default
  end

  def down
  end
end
