# encoding: utf-8
# == Schema Information
#
# Table name: recommend_products
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  product_id :integer(4)
#  opinion    :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class RecommendProduct < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  
  has_many :rec_product_comments, :dependent => :destroy
    
  attr_accessible :id, :user_id, :product_id, :opinion
  
  def last_comment
    rec_comments = self.rec_product_comments
    unless rec_comments.empty?
      rec_comments[-1]
    else
      nil
    end
  end
  
  def comments_count
    self.rec_product_comments.count
  end
  
  def timeline_resume
    "<b>#{self.user.name}</b> recomendou o produto <b>#{self.product.name}</b> do <b>#{self.product.partner.company_name}</b>: <b>#{self.opinion}</b>".html_safe
  end
  
  def facebook_resume
    "#{self.user.name} recomendou o produto #{self.product.name} do #{self.product.partner.company_name}: #{self.opinion}"
  end
  
  def self.by_offer offer
    RecommendProduct.find_all_by_product_id(Product.find_all_by_partner_id(offer.partner.id))
  end
  
end
