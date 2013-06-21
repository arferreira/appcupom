# == Schema Information
#
# Table name: social_links
#
#  username           :string(255)
#  social_id          :string(255)     not null
#  social_type        :string(255)     not null
#  image_url          :string(255)
#  access_toke_secret :string(255)
#  user_id            :integer(4)      not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  id                 :integer(4)      not null, primary key
#

class SocialLink < ActiveRecord::Base
  belongs_to :user
  
  def self.create_from_facebook client, user
    sl = SocialLink.new
    sl.username = client[:username]
    sl.social_type = client[:social_type]
    sl.social_id = client[:social_id]
    sl.image_url = client[:image_url]
    sl.user_id = user[:id]
    sl.access_token = client[:graph].access_token
    
    sl.save
    
    return sl
  end

  def open_graph
    if social_type == "F"
      begin
        Koala::Facebook::API.new(access_token)
      rescue
        nil
      end
    else
      nil
    end
  end
end
