class AddBadgeIdToTimelineItem < ActiveRecord::Migration
  def change
    add_column :timeline_items, :badge_id, :integer

  end
end
