# == Schema Information
#
# Table name: user_credits
#
#  id            :integer(4)      not null, primary key
#  user_id       :integer(4)
#  reason        :string(255)
#  value         :integer(10)
#  current_value :integer(10)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

class UserCredit < ActiveRecord::Base
  belongs_to :user
end
