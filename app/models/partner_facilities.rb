# == Schema Information
#
# Table name: partner_facilities
#
#  partner_id  :integer(4)      not null
#  facility_id :integer(4)      not null
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class PartnerFacilities < ActiveRecord::Base
  #relations
  belongs_to :partner
  belongs_to :facility
  
end
