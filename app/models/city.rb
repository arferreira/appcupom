# == Schema Information
#
# Table name: cities
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  latitude   :decimal(15, 10)
#  longitude  :decimal(15, 10)
#  radius     :integer(4)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class City < ActiveRecord::Base
end
