class AddRecommendOfferIdToTimelineItem < ActiveRecord::Migration
  def change
    add_column :timeline_items, :recommend_offer_id, :integer

  end
end
