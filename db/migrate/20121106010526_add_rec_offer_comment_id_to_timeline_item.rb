class AddRecOfferCommentIdToTimelineItem < ActiveRecord::Migration
  def change
    add_column :timeline_items, :rec_offer_comment_id, :integer

  end
end
