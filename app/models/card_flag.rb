# == Schema Information
#
# Table name: card_flags
#
#  id         :integer(4)      not null, primary key
#  flag       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  code       :string(255)
#

class CardFlag < ActiveRecord::Base
end
