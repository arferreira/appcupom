# encoding: utf-8
class ApplicationController < ActionController::Base
  #before_filter :setup_breadcrumb_navigation
  # before_filter :authenticate_http

  protect_from_forgery
  include SessionsHelper
  include CuponsHelper
  include TwitterOauthHelper
  include MoipHelper
  require 'koala'

#  rescue_from Koala::Facebook::APIError, :with => :refresh_facebook

  def get_client
    Koala::Facebook::OAuth.new(FacebookAPI.app_id, FacebookAPI.app_secret, FacebookAPI.oauth_callback_url)
  end


  def d (*args)
    unless Rails.env.production?
      p '                    '
      p '   DEBUGGER START   '
      p '   -   '
      p '   -   '
      args.each do |arg|
        p arg
        p '============================================='
      end
      p '   -   '
      p '   -   '
      p '   DEBUGGER END   '
      p '                    '
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404.html", :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def array_of_ids object_array
    out = []
    object_array.each do |object|
      out.push object.id
    end
    out
  end

  def prepare_for_mobile
    prepend_view_path Rails.root + 'app' + 'views_mobile'
  end

  def check_for_mobile
    session[:set_mobile] = params[:mobile] if params[:mobile]
    prepare_for_mobile if mobile_device?
  end

  def mobile_device?
    if session[:set_mobile]
      session[:set_mobile] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end
  helper_method :mobile_device?

  def include_google?
    session[:include_google] == "1"
  end
  helper_method :include_google?

  def require_google
    session[:include_google] = "1"
  end

  def include_moip?
    session[:include_moip] == "1"
  end
  helper_method :include_moip?

  def require_moip
    session[:include_moip] = "1"
  end


  protected

  #def setup_breadcrumb_navigation
  #  if params[:action] == "index"
  #    session[:breadcrumbs] = nil
  #  else
  #    url = URI::parse request.referer
  #    if session[:breadcrumbs].nil?
  #      session[:breadcrumbs] = url.path.strip
  #    else
  #      session[:breadcrumbs] = session[:breadcrumbs] + ", "+url.path if session[:breadcrumb]
  #    end
  #    session[:breadcrumbs] = session[:breadcrumbs].split(", ").uniq.join(",")
  #  end
  #end

  def authenticate_http
    authenticate_or_request_with_http_basic do |username, password|
      username == "nowon" && password == "n0w0nDna"
    end
  end

  def add_breadcrumb name, url = ''
    @breadcrumbs ||= []
    url = eval(url) if url =~ /_path|_url|@/
    @breadcrumbs << [name, url]
  end

  def self.add_breadcrumb name, url, options = {}
    before_filter options do |controller|
      controller.send(:add_breadcrumb, name, url)
    end
  end

  def check_facebook
    if current_user && current_user.is_a?(User)
      fbu_database = current_user.facebook_user
      fbu_session = session[:facebook_user]
      if fbu_database || fbu_session
        begin
          client = Koala::Facebook::API.new(fbu_database.access_token)
          credentials = client.get_object("me")
        rescue
          session[:facebook_client] = get_client
          curr_request = {}
          curr_request[:method] = request.method
          curr_request[:fullpath] = request.fullpath
          curr_request[:params] = params
          session[:curr_request] = curr_request
          redirect_to session[:facebook_client].url_for_oauth_code(:callback => "#{FacebookAPI.oauth_callback_url}?fb_reauth=true", :permissions => "email, user_status, publish_stream, publish_actions")
        end
      end
    end
  end

  add_breadcrumb 'Nowon', '/'
end
