module TwitterOauthHelper
  
  def get_request_token
    consumer = OAuth::Consumer.new( TwitterAPI.ckey, TwitterAPI.csecret, {:site => TwitterAPI.api_url} )
    request_token = consumer.get_request_token( :oauth_callback => TwitterAPI.oauth_callback_url)

    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
  end


  def get_twitter_client( access_token, access_token_secret)
  Twitter.configure do |config|
    config.consumer_key   = TwitterAPI.ckey
    config.consumer_secret  = TwitterAPI.csecret
    config.oauth_token    = access_token
    config.oauth_token_secret = access_token_secret
  end    
    
    return Twitter::Client.new    
  end


  def auth( consumer )
    consumer = OAuth::Consumer.new( TwitterAPI.ckey, TwitterAPI.csecret, {:site => TwitterAPI.api_url} )
    session[:request_token] = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_token_secret])
    
    access_token = session[:request_token].get_access_token( :oauth_verifier => params[:oauth_verifier] )
    session[:access_token] = access_token.token
    session[:access_token_secret] = access_token.secret
  
    user_info = verify_credentials(access_token)
    
    # session[:twitter_id] = user_info['id'];
    # session[:screen_name] = user_info['screen_name']
    # session[:profile_image_url] = user_info['profile_image_url']
  end

  
  def verify_credentials( access_token )
    response = access_token.get('/account/verify_credentials.json')
    case response
    when Net::HTTPSuccess
        credentials=JSON.parse(response.body)
      raise err unless credentials.is_a? Hash
    
      credentials
    else
      raise TwitterOauth::APIError
    end
  rescue => err
      puts "Exception in verify_credentials: #{err}"
    raise err
  end
  
  def twitter_follow_app username
    app_twitter_client = get_twitter_client( TwitterAPI.app_atoken, TwitterAPI.app_asecret)
    begin
      app_twitter_client.follow username
    rescue StandardError => e
      puts '--Failled to follow--'
    end
  end
  
end
