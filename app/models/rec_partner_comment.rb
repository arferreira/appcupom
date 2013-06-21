# encoding: utf-8
# == Schema Information
#
# Table name: rec_partner_comments
#
#  id                   :integer(4)      not null, primary key
#  recommend_partner_id :integer(4)
#  user_id              :integer(4)
#  opinion              :text
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#

class RecPartnerComment < ActiveRecord::Base
  belongs_to :recommend_partner
  belongs_to :user
  
  
  def timeline_resume
    "<b>#{self.user.name}</b> comentou na recomendação do estabelecimento <b>#{self.recommend_partner.partner.company_name}</b> feita por <b>#{self.recommend_partner.user.name}</b>".html_safe
  end
  
  def facebook_resume
    "#{self.user.name} comentou na recomendação do estabelecimento #{self.recommend_partner.partner.company_name} feita por #{self.recommend_partner.user.name}"
  end
  
end
