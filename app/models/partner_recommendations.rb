# == Schema Information
#
# Table name: partner_recommendations
#
#  partner_id        :integer(4)      not null
#  recommendation_id :integer(4)      not null
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

class PartnerRecommendations < ActiveRecord::Base
  #relations
  belongs_to :partner
  belongs_to :recommendation
  
end
