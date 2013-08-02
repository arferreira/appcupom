# encoding: utf-8
class SessionsController < ApplicationController
  #before_filter :authenticate, :only => [:splash]
  before_filter :check_if_signed_in, :only => :new
  before_filter :check_facebook, :except => [:destroy]

  def new
    @access_type = params[:access_type]
    d('Access type: ', @access_type)
    case @access_type
      when PARTNER_TYPE
        #@title = 'Partner Signin'
      when ADMIN_TYPE
        #@title = 'Admin Signin'
      else
        @access_type = USER_TYPE
        # @title = 'User Signin'
    end
    
    @no_header = true
    @dark = true
  end
  
  
  def create
    access_type = params[:access_type]
    
    d('create in ', access_type)
    
    case access_type
      when PARTNER_TYPE
        session[:access_type] = PARTNER_TYPE 
        partner = Partner.authenticate(params[:session][:email],
                               params[:session][:password])
      when ADMIN_TYPE
        session[:access_type] = ADMIN_TYPE  
        admin = Administrator.authenticate(params[:session][:email],
                               params[:session][:password])
      when USER_TYPE
        session[:access_type] = USER_TYPE  
        user = User.authenticate(params[:session][:email],
                               params[:session][:password])
        
        return unless login_facebook user.facebook_user if !user.nil? && user.facebook_user
      else
        flash.now[:error] = "Tipo de acesso não encontrado."
        # render 'new'
    end
        
    accessor = user || partner || admin
    
    if accessor.nil?
      flash.now[:error] = "Invalid email/password combination."
      
      if access_type == PARTNER_TYPE
        redirect_to "/p/signin", notice: 'Usuário ou Senha inválida!'
      elsif access_type == ADMIN_TYPE
        redirect_to "/a/signin", notice: 'Usuário ou Senha inválida!'
      else
        redirect_to "/signin", notice: 'Usuário ou Senha inválida!'
      end
    else
      sign_in accessor
      
      #if user is login in with facebook and already has a account
      if facebook_logged? && accessor.access_type != PARTNER_TYPE && accessor.social_links.empty? 
        SocialLink.create_from_facebook(session[:facebook_user], accessor) unless session[:facebook_user].nil?
      end
      
      #TODO se for parceiro redirecionar para DASHBOARD
      if accessor.access_type != PARTNER_TYPE
        redirect_to root_path
      else
        redirect_to dashboard_partner_path(accessor)#{}"Dashboard", :controller => :partners, :action => :dashboard
      end
    end
  end 
   
  def destroy
    access_type = session[:access_type]
    
    cookies.delete(:auth_token)
    sign_out
    session.delete :access_type        
    if access_type == PARTNER_TYPE
      redirect_to "/p/signin"
    elsif access_type == ADMIN_TYPE
      redirect_to "/a/signin"
    elsif mobile_device?
      redirect_to '/signin'
    else
      redirect_to root_path
    end
    
    
  end
  
  def splash
    access_type = session[:access_type]

    if signed_in? PARTNER_TYPE
      redirect_to dashboard_partner_path(current_user)
    elsif signed_in? ADMIN_TYPE
      redirect_to dashboard_administrator_path(current_user)
    else
      unless session[:location_time].nil?
        timeout = Time.now - session[:location_time] > MAX_GPS_CACHE_TIME
      end

      if session[:location_time].nil? || (timeout && signed_in?)
        @request_location = "true"
        @location_callback = "/offers"
      else
        @request_location = "true"
      end  

      respond_to do |format|
        @no_back = true
        @menu = true
        @nowon = true
        @offer_list = true
        @search = true

        if (signed_in? || facebook_logged?)
          if session[:location_time].nil? || timeout || !session[:gps]
            format.html
          else
            format.html {redirect_to '/offers'}
          end
        else
          format.html {redirect_to '/comofunciona'}
        end
      end
    end
  end
  
  
  private 
  
  def authenticate
    deny_access unless (signed_in? USER_TYPE) || (signed_in? PARTNER_TYPE) || (signed_in? ADMIN_TYPE)
  end

  def check_if_signed_in
    if params[:access_type] && session[:access_type] != params[:access_type]
      access_type = session[:access_type]
      
      cookies.delete(:auth_token)
      sign_out
      session.delete :access_type
    else
      redirect_to root_path if signed_in?
    end
  end
  
  def login_facebook social_link
    session[:facebook_client] = get_client
    begin
      raise Exception if social_link.access_token.nil?
      client = Koala::Facebook::API.new(social_link.access_token) 
      
      credentials = client.get_object("me")
      session[:facebook_user] = {
                                 :username => credentials["username"] || credentials["name"],
                                 :social_type => FacebookAPI.social_type,
                                 :social_id => credentials["id"],
                                 :image_url => client.get_picture(credentials["id"]),
                                 :graph => client
                                }
    rescue
      redirect_to session[:facebook_client].url_for_oauth_code(:callback => FacebookAPI.oauth_callback_url, :permissions => "email, user_status, publish_stream, publish_actions")
      return false
    end
  end

end
