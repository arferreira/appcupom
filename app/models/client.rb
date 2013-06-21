# == Schema Information
#
# Table name: clients
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Client < ActiveRecord::Base
  #relations
  has_many :ads
end
