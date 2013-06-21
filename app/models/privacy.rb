# == Schema Information
#
# Table name: privacies
#
#  id          :integer(4)      not null, primary key
#  description :string(255)
#  default     :boolean(1)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  user_type   :string(2)
#

class Privacy < ActiveRecord::Base
  has_many :user_privacies
  has_many :users, :through => :user_privacies
  
end
