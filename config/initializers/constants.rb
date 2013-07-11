USER_TYPE = 'u'
PARTNER_TYPE = 'p'
ADMIN_TYPE = 'a'
PROFIT = 10
CREDIT_RULE = 'c'
PRODUCT_RULE = 'p'
PRODUCT_OFFER = 'po'
PERCENT_OFFER = 'pco'
CREDIT_OFFER = 'co'
PICS_PER_OFFER = 1
PRODS_PER_OFFER = 3
NEEDS_APPROVAL = Rails.env.development? ? false : true
INITIAL_DISCOUNT = 30
BUSINESS_HOURS = []
MIN_CUPON = 1
MAX_CUPON = 500
DOMAIN = "dev.nowon.com"
MAX_GPS_CACHE_TIME = 1.hour
#MAX_GPS_CACHE_TIME = 2.minutes


#  recommend_comment_id    :integer
#  recommend_partner_id    :integer
#  recommend_product_id    :integer
#  wish_product_id         :integer
#  wish_product_comment_id :integer
#  offer_id                :integer
#  product_id              :integer
class TimelineType
  #offer_id
  #user.share TimelineType.offer, {:offer_id => @offer.id}
  def self.offer
    "OF"
  end
  
  #product_id
  #no used
  def self.product
    "PD"
  end
  
  #wish_product_id
  #user.share TimelineType.wish_product, {:wish_product_id => @wish_product.id}
  def self.wish_product
    "WP"
  end
  
  #wish_product_comment_id
  #user.share TimelineType.wish_product_comment, {:wish_product_comment_id => @wish_product_comment.id}
  def self.wish_product_comment
    "WPC"
  end
  
  #recommend_partner_id
  #@user.share TimelineType.recommend_partner, {:recommend_partner_id => @recommend_partner.id}
  def self.recommend_partner
    "RPT"
  end
  
  #recommend_product_id
  #@user.share TimelineType.recommend_product, {:recommend_product_id => @recommend_product.id}
  def self.recommend_product
    "RPD"
  end
  
  #recommend_offer_id
  #@user.share TimelineType.recommend_product, {:recommend_product_id => @recommend_product.id}
  def self.recommend_offer
    "RO"
  end
  
  #rec_partner_comment_id
  #@user.share TimelineType.rec_partner_comment, {:rec_partner_comment_id => @comment.id}
  def self.rec_partner_comment
    "RPAC"
  end
  
  #rec_product_comment_id
  #@user.share TimelineType.rec_product_comment, {:rec_product_comment_id => @comment.id}
  def self.rec_product_comment
    "RPDC"
  end
  
  def self.rec_offer_comment
    "ROC"
  end
  
  def self.badge
    "BDG"
  end
  
  def self.friend
    "FRI"
  end
end



class PrivacyType
  def self.offer
    1
  end

  def self.wish_product
    2
  end

  def self.wish_product_comment
    3
  end

  def self.recommend_partner
    4
  end

  def self.recommend_product
    5
  end

  def self.rec_partner_comment
    6
  end

  def self.rec_product_comment
    7
  end
  
  def self.badge
    8
  end
  
  def self.friend
    9
  end
  
  def self.recommend_offer
    10
  end
  
  def self.rec_offer_comment
    11
  end
end