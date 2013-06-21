# == Schema Information
#
# Table name: user_privacies
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  privacy_id :integer(4)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  nowon      :boolean(1)      default(FALSE), not null
#  twitter    :boolean(1)
#  facebook   :boolean(1)
#

class UserPrivacy < ActiveRecord::Base
  belongs_to :user
  belongs_to :privacy
end
