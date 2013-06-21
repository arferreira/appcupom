# encoding: utf-8
# == Schema Information
#
# Table name: rec_product_comments
#
#  id                   :integer(4)      not null, primary key
#  user_id              :integer(4)
#  recommend_product_id :integer(4)
#  opinion              :text
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#

class RecProductComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :recommend_product
  
  def timeline_resume
    "<b>#{self.user.name}</b> comentou na recomendação do produto <b>#{self.recommend_product.product.name}</b> feita por <b>#{self.recommend_product.user.name}</b>".html_safe
  end
  
  def facebook_resume
    "#{self.user.name} comentou na recomendação do produto #{self.recommend_product.product.name} feita por #{self.recommend_product.user.name}"
  end
end
