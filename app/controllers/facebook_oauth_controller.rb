class FacebookOauthController < ApplicationController
  require 'koala'
  
  def login
    reset_session
    
    session[:facebook_client] = get_client
    
    redirect_to session[:facebook_client].url_for_oauth_code(:callback => FacebookAPI.oauth_callback_url, :permissions => "email, user_status, publish_stream, publish_actions")
  rescue => err
  end
  
  def terminate
    client = session[:facebook_client]
    if client.nil?
      redirect_to '/', notice: 'Error on FacebookAPI'
    else
      begin
        @access_token = client.get_access_token(params[:code]) if params[:code]
      rescue Exception => e
        begin
          @access_token = client.get_access_token(params[:code]) if params[:code]
        rescue Exception => e
          redirect_to "/facebook/login"
        end
      end
      access_token = @access_token
      client = Koala::Facebook::API.new(access_token) 
      
      credentials = client.get_object("me")
      session[:facebook_user] = {
                                 :username => credentials["username"] || credentials["name"],
                                 :social_type => FacebookAPI.social_type,
                                 :social_id => credentials["id"],
                                 :image_url => client.get_picture(credentials["id"]),
                                 :graph => client
                                }


      
      session.delete :facebook_client
      
      soc_link = SocialLink.find_by_social_id_and_social_type(credentials["id"], FacebookAPI.social_type)
      current_user = User.find_by_email credentials["email"]
      sign_in current_user if current_user
      if soc_link.nil?
        #If user is logging from inside de app
        if signed_in?
          fbu = current_user.facebook_user
          if fbu
            fbu = current_user.facebook_user
            fbu.access_token = access_token
            fbu.save
          else
            soc_link = SocialLink.create_from_facebook(session[:facebook_user], current_user) unless session[:facebook_user].nil?
            
            soc_link[:access_token] = access_token
            soc_link.save
          end
          
          #FacebookGraph.create_relationships(client, current_user)
          
          redirect_to '/' 
        else
          flash[:facebook_user_form] = credentials["name"] #session[:facebook_user][:username]
          flash[:facebook_email_form] = credentials["email"]
          redirect_to '/users/new?origin=oauth_fb'
        end
      else
        current_user = soc_link.user
        sign_in current_user
        
        soc_link[:access_token] = access_token
        soc_link.save
        #FacebookGraph.create_relationships(client, current_user)
        
        redirect_to '/' 
      end
    end    
  end

end