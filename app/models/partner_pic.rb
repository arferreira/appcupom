# == Schema Information
#
# Table name: partner_pics
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)
#  description        :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer(4)
#  image_updated_at   :datetime
#  partner_id         :integer(4)
#

class PartnerPic < ActiveRecord::Base
  belongs_to :partner
  has_many :offers
  has_attached_file :image, :styles => {
                            :banner => {
                              :geometry => "273x65#",
                              :quality => 60,
                              :format => "jpg"
                              },
                            :banner_big => {
                              :geometry => "640x222#",
                              :quality => 60,
                              :format => "jpg"
                            },
                            :small => {
                              :geometry => "156x117#",
                              :quality => 60,
                              :format => "jpg"
                            },
                            :thumb => {
                              :geometry => "72x72#",
                              :quality => 60,
                              :format => "jpg"
                            }
                            
                          }
end
