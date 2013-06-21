# encoding: utf-8
# == Schema Information
#
# Table name: recommend_offers
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  offer_id   :integer(4)
#  opinion    :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class RecommendOffer < ActiveRecord::Base
  belongs_to :user
  belongs_to :offer
  
  has_many :rec_offer_comments, :dependent => :destroy
    
  attr_accessible :id, :user_id, :offer_id, :opinion
  
  def last_comment
    rec_comments = self.rec_offer_comments
    unless rec_comments.empty?
      rec_comments[-1]
    else
      nil
    end
  end
  
  def comments_count
    self.rec_offer_comments.count
  end
  
  def timeline_resume
    "<b>#{self.user.name}</b> recomendou a oferta <b>#{self.offer.resume}</b> do <b>#{self.offer.partner.company_name}</b>: <b>#{self.opinion}</b>".html_safe
  end
  
  def facebook_resume
    "#{self.user.name} recomendou a oferta #{self.offer.resume} do #{self.offer.partner.company_name}: #{self.opinion}".html_safe
  end
  
end
