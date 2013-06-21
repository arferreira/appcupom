class TwitterAPI
  def self.social_type
    social_type = 'T'
  end

  def self.ckey
    if Rails.env.production? || Rails.env.pre?
      ckey = ""
    else
      ckey = ""
    end
  end

  def self.csecret
    if Rails.env.production? || Rails.env.pre?
      csecret = ""
    else
      csecret = ""
    end
  end

  def self.api_url
    api_url = "https://api.twitter.com"
  end

  def self.oauth_callback_url
    if Rails.env.production? || Rails.env.pre?
      oauth_callback_url = "http://nowon.com.br/twitter/terminate"
    else
      oauth_callback_url = "http://127.0.0.1:3000/twitter/terminate"
    end
  end

  def self.oauth_twitter_url
    oauth_twitter_url = "https://api.twitter.com/oauth/authenticate?oauth_token="
  end

  def self.app_atoken
    if Rails.env.production? || Rails.env.pre?
      my_atoken = ""
    else
      my_atoken = ""
    end
  end

  def self.app_asecret
    if Rails.env.production? || Rails.env.pre?
      my_asecret = ""
    else
      my_asecret = ""
    end
  end

  def self.app_twitter
    main_twitter = "Nowon"
  end

end

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

class Moip
  def self.username
    "dna"
  end

  def self.token
    if Rails.env.production? || Rails.env.pre?
      "KP7DDMGAYJ5NQZTLSNWZT5IUTWEI7C0G"
    else
      "NRENT5ABO7UHPZG5MDFOJ2QSH4JGP6E8"
    end
  end

  def self.secret
    if Rails.env.production? || Rails.env.pre?
      "PI7WHTWJAEDK3UBMVLG0KAVZQVJDVEHYCKEPOBNQ"
    else
      "2QTYHHYHHQFKRQAFRRC3C9YY1KORWSN8BEYABJTH"
    end
  end

  def self.url
    if Rails.env.production? || Rails.env.pre?
      "https://www.moip.com.br/ws/alpha/EnviarInstrucao/Unica"
    else
      "https://desenvolvedor.moip.com.br/sandbox/ws/alpha/EnviarInstrucao/Unica"
       #"https://www.moip.com.br/ws/alpha/EnviarInstrucao/Unica"
    end
  end
end

class Google
  def self.key
    "AIzaSyBgP69wSIFNJeEftRGV-_UnJYjYe1GwWCA"
  end
end

