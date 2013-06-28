class FacebookGraph < ActionController::Base

  def self.post_message client, text, url = nil, action = nil, object = nil, options
    begin
      if client
        if url
          client.put_wall_post text, options.merge({ :link => url })
          if action && object
            client.put_connections("me", "#{FacebookAPI.app_namespace}:#{action}", :"#{object}" => url)
          end
        else
          if text.include? "trazcupom"
            client.put_wall_post text
          else
            client.put_wall_post text << ' www.trazcupom.com.br'
          end
        end
      end
    rescue Koala::Facebook::APIError => koala_error
    end
=begin
    unless client.nil?
    # if Rails.env.production?
    if text.include? "nowon"
      client.put_wall_post text
    else
      client.put_wall_post text << ' www.nowon.com.br'
    end
    # else
      # puts '---FacebookGraph post_message: #{text}'
    # end
    end
  rescue => err
=end
  end

  def self.create_relationships(client, user)
    begin
      friends_array = client.get_connections('me','friends')

      friends_array.each do |f_web_id|
        soc_link = SocialLink.find_by_social_id(f_web_id["id"])
        my_friend = soc_link.user unless soc_link.nil?
        unless my_friend.nil?
          unless user.is_my_friend? my_friend
            Friendship.friend user, my_friend, true
          end
        end
      end
    rescue Koala::Facebook::APIError => koala_error
    end
  end

end