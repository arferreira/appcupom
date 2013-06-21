# == Schema Information
#
# Table name: mail_privacies
#
#  id          :integer(4)      not null, primary key
#  description :string(255)
#  default     :boolean(1)
#  user_type   :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class MailPrivacy < ActiveRecord::Base
  has_many :user_privacies
end
