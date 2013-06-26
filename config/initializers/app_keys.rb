class FacebookAPI
  def self.social_type
    social_type = 'F'
  end

  def self.facebook_api_url
    facebook_api_url = 'https://graph.facebook.com'
  end

  def self.app_namespace
    if Rails.env.production? #|| Rails.env.pre?
      app_namespace = "nowon"
    else
      app_namespace = "nowon-dev"
    end
  end

  def self.app_id
    # nowon
    if Rails.env.production? #|| Rails.env.pre?
      app_id = "446094325449761"
    else
    # nowon-dev
      app_id = "554176287943017"
    end
  end

  def self.app_secret
    # nowon
    if Rails.env.production? #|| Rails.env.pre?
      app_secret = "3ed8c0f5493a317a8ce33ab8df8ed982"
    else
    # nowon-dev
      app_secret = "f7ccc7dee495c4cd246f60f3771ac1ff"
    end
  end

  def self.oauth_callback_url
    if Rails.env.production? #|| Rails.env.pre?
      # oauth_callback_url = "http://nowon.com.br/facebook/terminate"
      oauth_callback_url = "http://www.nowon.com.br/facebook/terminate"
    else
      oauth_callback_url = "http://pre.nowon.com.br/facebook/terminate"
      #oauth_callback_url = "http://lvh.me:3000/facebook/terminate"
    end
  end
end
class Google
  def self.key
    "AIzaSyBgP69wSIFNJeEftRGV-_UnJYjYe1GwWCA"
  end
end