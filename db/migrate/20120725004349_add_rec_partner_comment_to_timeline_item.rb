class AddRecPartnerCommentToTimelineItem < ActiveRecord::Migration
  def change
    add_column :timeline_items, :rec_product_comment_id, :integer
    add_index :timeline_items, :rec_product_comment_id
    add_column :timeline_items, :rec_partner_comment_id, :integer
    add_index :timeline_items, :rec_partner_comment_id
   
    remove_column :timeline_items, :recommend_comment_id
    
  end
end
