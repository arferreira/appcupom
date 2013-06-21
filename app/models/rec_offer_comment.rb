# encoding: utf-8
# == Schema Information
#
# Table name: rec_offer_comments
#
#  id                 :integer(4)      not null, primary key
#  user_id            :integer(4)
#  recommend_offer_id :integer(4)
#  opinion            :text
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

class RecOfferComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :recommend_offer
  
  def timeline_resume
    "<b>#{self.user.name}</b> comentou na recomendação de oferta <b>#{self.recommend_offer.offer.resume}</b> feita por <b>#{self.recommend_offer.user.name}</b>".html_safe
  end
  
  def facebook_resume
    "#{self.user.name} comentou na recomendação de oferta #{self.recommend_offer.offer.resume} feita por #{self.recommend_offer.user.name}"
  end
end
