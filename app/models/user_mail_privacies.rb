# == Schema Information
#
# Table name: user_mail_privacies
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)
#  mail_privacy_id :integer(4)
#  choice          :boolean(1)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class UserMailPrivacies < ActiveRecord::Base
  belongs_to :user
  belongs_to :mail_privacy
end
