# == Schema Information
#
# Table name: partner_comments
#
#  partner_id :integer(4)      not null
#  user_id    :integer(4)      not null
#  comment    :text            default(""), not null
#  approved   :boolean(1)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class PartnerComment < ActiveRecord::Base
  belongs_to :partner
  belongs_to :user
end
