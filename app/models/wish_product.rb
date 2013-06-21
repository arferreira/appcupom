# == Schema Information
#
# Table name: wish_products
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  product_id :integer(4)
#  opinion    :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class WishProduct < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  
  has_many :wish_product_comments, :dependent => :destroy
  
  def last_comment
    wish_comments = self.wish_product_comments
    unless wish_comments.empty?
      wish_comments[-1]
    else
      nil
    end
  end
  
  def comments_count
    self.wish_product_comments.count
  end
  
  def timeline_resume
    "<b>#{self.user.name}</b> deseja degustar <b>#{self.product.name}</b> no <b>#{self.product.partner.company_name}</b>: <b>#{self.opinion}</b>".html_safe
  end
  
  def facebook_resume
    "#{self.user.name} deseja degustar #{self.product.name} no #{self.product.partner.company_name}: #{self.opinion}"
  end
  
  def self.by_offer offer
    self.by_partner offer.partner
  end
  
  def self.by_partner partner
    self.find_by_sql(["SELECT wish_products.* 
                       FROM wish_products
                       JOIN products ON wish_products.product_id = products.id
                       WHERE products.partner_id = ?
                       ",partner.id])
  end
  
  def self.count_by_offer offer
    products = offer.products
    return self.count products
  end
  
  def self.count_by_partner partner
    products = partner.products
    return self.count products
  end
  
  def self.count products
    count = 0
    
    products.each do |product|
      count = count + 1 unless product.wish_products.empty?
    end
    
    return count
  end
  
end
