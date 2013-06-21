class AddResumeStringToRules < ActiveRecord::Migration
  def change
    add_column :rules, :resume, :string
  
  end
end
