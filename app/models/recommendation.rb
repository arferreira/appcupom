# == Schema Information
#
# Table name: recommendations
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Recommendation < ActiveRecord::Base
  #relations
  has_many :partner_recommendations
  has_many :partners, :through => :partner_recommendations
end
