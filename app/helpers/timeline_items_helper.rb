module TimelineItemsHelper
  
  def get_layout_by_type timeline_item
    case timeline_item.item_type
      when TimelineType.offer
        "timeline_items/offer_item"
      when TimelineType.wish_product
        "timeline_items/wish_product_item"
      when TimelineType.wish_product_comment
        "timeline_items/wish_product_comment_item"
      when TimelineType.recommend_partner
        "timeline_items/recommend_partner_item"
      when TimelineType.recommend_product
        "timeline_items/recommend_product_item"
      when TimelineType.recommend_offer
        "timeline_items/recommend_offer_item"
      when TimelineType.rec_partner_comment
        "timeline_items/rec_partner_comment_item"
      when TimelineType.rec_product_comment
        "timeline_items/rec_product_comment_item"
      when TimelineType.rec_offer_comment
        "timeline_items/rec_offer_comment_item"
      when TimelineType.badge
        "timeline_items/badge_item"
      when TimelineType.friend
        "timeline_items/friend_item"
    end
  end
  
  def get_locals_by_type timeline_item
    case timeline_item.item_type
      when TimelineType.offer
        offer = timeline_item.offer
        {
          :timeline_item => timeline_item, 
          :offer => offer,
          :last_comment => offer.last_comment,
          :comments_count => offer.comments_count,
          :user => timeline_item.user
        } unless timeline_item.offer.nil?
      when TimelineType.wish_product
        wish_product = timeline_item.wish_product
        {
          :timeline_item => timeline_item, 
          :wish_product => wish_product, 
          :last_comment => wish_product.last_comment,
          :comments_count => wish_product.comments_count,
          :product => wish_product.product
        } unless timeline_item.wish_product.nil?
      when TimelineType.wish_product_comment
        wish_product_comment = timeline_item.wish_product_comment
        {
          :timeline_item => timeline_item, 
          :wish_product_comment => wish_product_comment,
          :wish_product => wish_product_comment.wish_product, 
          :comments_count => wish_product_comment.wish_product.comments_count,
          :last_comment => wish_product_comment
        } unless timeline_item.wish_product_comment.nil?
      when TimelineType.recommend_partner
        recommend_partner = timeline_item.recommend_partner
        {
          :timeline_item => timeline_item,
          :recommend_partner => recommend_partner,
          :comments_count => recommend_partner.comments_count,
          :last_comment => recommend_partner.last_comment        
        } unless timeline_item.recommend_partner.nil?
      when TimelineType.recommend_product
        recommend_product = timeline_item.recommend_product
        {
          :timeline_item => timeline_item,
          :recommend_product => recommend_product,
          :comments_count => recommend_product.comments_count,
          :last_comment => recommend_product.last_comment         
        } unless timeline_item.recommend_product.nil?
      when TimelineType.recommend_offer
        recommend_offer = timeline_item.recommend_offer
        {
          :timeline_item => timeline_item,
          :recommend_offer => recommend_offer,
          :comments_count => recommend_offer.comments_count,
          :last_comment => recommend_offer.last_comment         
        } unless timeline_item.recommend_offer.nil?
      when TimelineType.rec_partner_comment
        rec_partner_comment = timeline_item.rec_partner_comment
        {
          :timeline_item => timeline_item,
          :rec_partner_comment => rec_partner_comment,
          :recommend_partner => rec_partner_comment.recommend_partner,
          :comments_count => rec_partner_comment.recommend_partner.comments_count,
          :last_comment => rec_partner_comment   
        } unless timeline_item.rec_partner_comment.nil?
      when TimelineType.rec_product_comment
        rec_product_comment = timeline_item.rec_product_comment
        {
          :timeline_item => timeline_item,
          :rec_product_comment => rec_product_comment,
          :recommend_product => rec_product_comment.recommend_product,
          :comments_count => rec_product_comment.recommend_product.comments_count,
          :last_comment => rec_product_comment       
        } unless timeline_item.rec_product_comment.nil?
      when TimelineType.rec_offer_comment
        rec_offer_comment = timeline_item.rec_offer_comment
        {
          :timeline_item => timeline_item,
          :rec_offer_comment => rec_offer_comment,
          :recommend_offer => rec_offer_comment.recommend_offer,
          :comments_count => rec_offer_comment.recommend_offer.nil? ? 0 : rec_offer_comment.recommend_offer.comments_count,
          :last_comment => rec_offer_comment       
        } unless timeline_item.rec_offer_comment.nil?
      when TimelineType.badge
        badge = timeline_item.badge
        {
          :timeline_item => timeline_item, 
          :badge => badge,
          :user => timeline_item.user
        } unless timeline_item.badge.nil?
      when TimelineType.friend
        friend = timeline_item.friend
        {
          :timeline_item => timeline_item, 
          :friend => friend,
          :user => timeline_item.user
        } unless timeline_item.friend.nil?
    end
  end
  
end
