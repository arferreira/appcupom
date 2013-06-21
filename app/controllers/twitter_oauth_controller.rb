class TwitterOauthController < ApplicationController
  
  def login
    reset_session
    get_request_token
    redirect_to TwitterAPI.oauth_twitter_url + session[:request_token]
  rescue => err
    if Rails.env.development?
       redirect_to 'twitter/terminate'
    end
  end

  def terminate
    user_info = auth(session[:request_token])   
    
    # client = get_twitter_client session[:access_token], session[:access_token_secret]
    
    session[:twitter_token] = [user_info['id'], session[:access_token], TwitterAPI.social_type]
    access_token_secret = session[:access_token_secret]
    
    session.delete(:request_token)
    session.delete(:request_token_secret)
    session.delete(:access_token)
    session.delete(:access_token_secret)
    
    twitter_follow_app user_info['screen_name']
    
    social_link = SocialLink.find_by_social_id_and_social_type(user_info['id'], TwitterAPI.social_type)
    if soc_link.nil?
      #TODO create SocialLink
      redirect_to '/users/new'
    else
      social_link[:access_token_secret] = access_token_secret
      redirect_to '/' if social_link.save 
    end
      
  end
    
end
