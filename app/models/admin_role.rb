# == Schema Information
#
# Table name: admin_roles
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)     not null
#  description :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class AdminRole < ActiveRecord::Base
  #relations
  has_many :administrators
  attr_accessible :name, :description
end
