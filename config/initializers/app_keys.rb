class FacebookAPI
  def self.social_type
    social_type = 'F'
  end

  def self.facebook_api_url
    facebook_api_url = 'https://graph.facebook.com'
  end

  def self.app_namespace
    if Rails.env.production? #|| Rails.env.pre?
      app_namespace = "trazcupomlogin"
    else
      app_namespace = "trazcupom-dev"
    end
  end

  def self.app_id
    # nowon
    if Rails.env.production? #|| Rails.env.pre?
      app_id = "294633027349454"
    else
    # nowon-dev
      app_id = "348626355240136"
    end
  end

  def self.app_secret
    # nowon
    if Rails.env.production? #|| Rails.env.pre?
      app_secret = "acfbf26585c4be9163d38c0836611c2b"
    else
    # nowon-dev
      app_secret = "d8a1be6f611f96893e798b2d2c010d3a"
    end
  end

  def self.oauth_callback_url
    if Rails.env.production? #|| Rails.env.pre?
      # oauth_callback_url = "http://nowon.com.br/facebook/terminate"
      oauth_callback_url = "http://www.trazcupom.com/facebook/terminate"
    else
      oauth_callback_url = "http://localhost:3000/facebook/terminate"
      #oauth_callback_url = "http://lvh.me:3000/facebook/terminate"
    end
  end
end
class Google
  def self.key
    "AIzaSyBgP69wSIFNJeEftRGV-_UnJYjYe1GwWCA"
  end
end