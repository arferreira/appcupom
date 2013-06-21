class AddFriendIdToTimelineItem < ActiveRecord::Migration
  def change
    add_column :timeline_items, :friend_id, :integer

  end
end
