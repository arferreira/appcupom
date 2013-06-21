# == Schema Information
#
# Table name: timeline_readers
#
#  id               :integer(4)      not null, primary key
#  user_id          :integer(4)
#  timeline_item_id :integer(4)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

class TimelineReader < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline_item
end
