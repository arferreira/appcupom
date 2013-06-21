# == Schema Information
#
# Table name: user_badges
#
#  user_id    :integer(4)      not null
#  badge_id   :integer(4)      not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class UserBadge < ActiveRecord::Base
  #relations
  belongs_to :user
  belongs_to :badge
  
  validates_uniqueness_of :user_id, :scope => :badge_id
end
