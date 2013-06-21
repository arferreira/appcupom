# == Schema Information
#
# Table name: ads
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)     not null
#  date_starts :date            not null
#  date_ends   :date            not null
#  client_id   :integer(4)      not null
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Ad < ActiveRecord::Base
  #relations
  belongs_to :client
end
