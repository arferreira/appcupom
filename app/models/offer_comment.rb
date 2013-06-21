# == Schema Information
#
# Table name: offer_comments
#
#  offer_id   :integer(4)      not null
#  user_id    :integer(4)      not null
#  comment    :text            default(""), not null
#  approved   :boolean(1)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class OfferComment < ActiveRecord::Base
  #relations
  belongs_to :offer
  belongs_to :user
end
