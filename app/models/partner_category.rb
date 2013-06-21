# encoding: utf-8
# == Schema Information
#
# Table name: partner_categories
#
#  partner_id  :integer(4)
#  category_id :integer(4)
#

class PartnerCategory < ActiveRecord::Base
  #relations
  belongs_to :partner
  belongs_to :category
  
end
