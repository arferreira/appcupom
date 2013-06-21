class CreateUserBadges < ActiveRecord::Migration
  def change
    create_table :user_badges, :id => false do |t|
      t.references :user, :null => false
      t.references :badge, :null => false

      t.timestamps
    end
    add_index :user_badges, :user_id
    add_index :user_badges, :badge_id
  end
end
