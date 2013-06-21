# encoding: utf-8
# == Schema Information
#
# Table name: sub_categories
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  category_id :integer(4)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class SubCategory < ActiveRecord::Base
  #relations
  belongs_to :category
  
end
