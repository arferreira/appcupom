# == Schema Information
#
# Table name: facilities
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Facility < ActiveRecord::Base
  #relations
  has_many :partner_facilities
  has_many :partners, :through => :partner_facilities

end
