# encoding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate, :except => [:new, :create]
  before_filter :authenticate_admin, :only => [:index]
  before_filter :check_facebook, :only => [:show]
  #before_filter :correct_user, :except => [:show, :new, :create, :index, :start_friendship]
  before_filter :correct_user, :only => [:dashboard, :update, :edit, :destroy, :edit_privacies, :badges, :timeline]
  # before_filter :check_for_mobile, :only => [:show]
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    #@user = User.find(params[:id])
    #Decorator
    @user = User.find(params[:id])

    @friend_requests = @user.friend_requests
    @facebook_friends = @user.facebook_friends

    #@friends = User.find
    @friends = @user.all_friends
    @badges = Badge.all
    @mybadges = @user.badges
    @products_rec  = @user.products_recommended
    @products_wish = @user.products_wished
    @partners_rec  = @user.partners_recommended

    add_breadcrumb @user.name, "users/#{@user.id}"


    return unless login_facebook @user.social_links.first if @user == current_user && !@user.nil? && @user.social_links.size > 0

    respond_to do |format|
      @title = "Perfil"
      @menu = true
      @config = true
      @no_back = true
      #@user_show_back = @user

      format.html # show.html.erb
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @fb_name = flash[:facebook_user_form]
    @fb_mail = flash[:facebook_email_form]
    flash.delete(:facebook_user_form)
    flash.delete(:facebook_email_form)
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    @random_password = (0...8).map{ o[rand(o.length)] }.join
    @user = User.new

    respond_to do |format|
      @title = "Criar conta"
      @menu = true
      @submenu = false

      format.html # new.html.erb
    end
  end

  # GET /users/1/edit
  def edit
    @user = current_user
    @title = "Configurações"
    @menu = true

    add_breadcrumb "Configurações", "users/#{@user.id}/edit"
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    password = params[:user][:password]
    @user[:active] = true

    respond_to do |format|
      if  @user.save
        #mailer:
        #UserMailer.registration_confirmation(@user).deliver

        #privacy
        create_user_privacies(@user)
        create_user_mail_privacies(@user)

        #social
        @social = SocialLink.create_from_facebook(session[:facebook_user], @user) unless session[:facebook_user].nil?
        #UserMailer.registration_confirmation(@user, password).deliver

        #badge:
        @user.new_badge session
        sign_in @user

        format.html {
          flash[:notice] = 'Usuário criado com sucesso'
          redirect_to offers_path(status: 'usuario criado com sucesso')
        }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'Campos alterados com sucesso!' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user[:active] = false
    @user[:email] = "user#{@user.id}@nowon.inactive"
    @user.save
    sign_out
    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  def privacies
    @user = current_user
    @user_privacies = @user.user_privacies.order(:id)
    @user_mail_privacies = @user.user_mail_privacies.order(:id)
    social_links = @user.social_links
    @social = social_links.first unless social_links.empty?
    @menu = true
    @title = "Facebook e notificações"

    add_breadcrumb "Configurações", "edit"
    add_breadcrumb "Privacidades", "users/#{@user.id}/privacies"
  end

  def remove_facebook
    user = current_user
    user.social_links.first.destroy

    redirect_to "/users/#{user.id}/privacies"
  end

  def edit_privacies
    save_user_privacies(params[:user_priv])

    save_mail_privacies(params[:mail_priv])

    respond_to do |format|
      format.html {redirect_to current_user}
    end
  end

  # GET /users/1/dashboard
  # GET /users/1/dashboard.json
  def dashboard
    @user = User.find(params[:id])
    @cupons = userCupons(@user)
    @numCupons = @cupons.count
    @moneySpent = 0

    @cupons.each do |cupon|
      @moneySpent += cupon.price
    end

    respond_to do |format|
      format.html # dashboard.html.erb
    end
  end

  def friends
    @user = User.find(params[:id])
    @friends = Friendship.all(:conditions => ['me_id = ?', @user])

    respond_to do |format|
      format.html
    end
  end

  def friend_requests
    @user = User.find(params[:id])

    @friend_requests = User.find_by_sql(['SELECT eu.* FROM friendships f, users eu, users amigo
                                           WHERE f.me_id = eu.id AND f.friend_id = amigo.id
                                             AND f.friend_id = :id AND f.me_id NOT IN
                                         (SELECT friend_id FROM friendships WHERE me_id = :id)', {:id => current_user.id}])

    respond_to do |format|
      format.html
    end
  end

  def start_friendship
    @user = User.find(params[:id])
    @me = current_user

    ok = Friendship.friend @me, @user, false

    respond_to do |format|
      if ok
        if @me.is_my_friend?(@user) && @me.am_i_a_friend?(@user)
          @me.share TimelineType.friend, {:friend_id => @user.id}

          @me.share_social @me.friend_facebook_resume(@me.name, @user.name), PrivacyType.friend
        end
        format.html { redirect_to user_path, notice: 'Solicitação de amizade enviada!' }
      else
        format.html { redirect_to user_path, notice: 'Erro! Solicitação não enviada.' }
      end
    end
  end

  def end_friendhip
    @user = User.find(params[:id])
    @me = current_user

    if @me.is_my_friend?(@user) and @user.is_my_friend?(@me)
        @me.unfriend!(@user)
        @user.unfriend!(@me)
    end

    respond_to do |format|
      format.html { redirect_to user_path }
      format.json { head :no_content }
    end
  end

  def deny_friendhip
    @user = User.find(params[:id])
    @me = current_user

    if @me.is_my_friend?(@user) == nil and @user.is_my_friend?(@me)
      d("#{@user.name}.unfriend!(#{@me.name})")
        @user.unfriend!(@me)
    elsif @me.is_my_friend?(@user) and @user.is_my_friend?(@me) == nil
      d("#{@me.name}.unfriend!(#{@user.name})")
        @me.unfriend!(@user)
    end

    respond_to do |format|
      format.html { redirect_to user_path(@me) }
      format.json { head :no_content }
    end
  end

  def remove_card
    user = User.find params[:user_id]
    user.user_cards.destroy_all

    redirect_to params[:callback]
  end

  def timeline
    @user = current_user
    @timeline_items = @user.timeline_items.order("created_at desc").page(params[:page]).per_page(3)

    add_breadcrumb "timeline", "users/#{@user.id}/timeline"

    respond_to do |format|
      @title = "timeline"
      @menu = true
      #@config = true BUG 13
      @img_user = "http://graph.facebook.com/#{current_user }/picture"
      @feed = true
      @no_back = true

      format.html
      format.js{ render :status => 250 }
    end
  end

  def badges
    @user = User.find(params[:id])
    @badges = UserBadge.find_all_by_user_id(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def credits
    @user = current_user
    @user_credits = @user.user_credits
    @total_value = @user.total_credit_value

    add_breadcrumb "Creditos", "users/#{@user.id}/credits"

    respond_to do |format|
      @menu = true
      @config = false
      @title = "Créditos"
      format.html
    end
  end

  def profile
    if current_user != nil
      @user = current_user

      respond_to do |format|
        format.html { redirect_to user_path(@user) }
      end
    else
      redirect_to root
    end
  end

  private

  def authenticate
    deny_access unless signed_in? USER_TYPE
  end

  def authenticate_admin
    deny_access unless signed_in? ADMIN_TYPE
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path, :notice => "Access Denied" )unless current_user?(@user)
  end

  def create_user_privacies user
    privacy = Privacy.find_all_by_user_type(USER_TYPE)
    unless privacy.nil?
      privacy.each do |priv|
        UserPrivacy.create( :user => user,
        :privacy => priv,
        :twitter => priv.default,
        :facebook => priv.default,
        :nowon => priv.default
        )
      end
    end
  end

  def create_user_mail_privacies user
    mailPrivacy = MailPrivacy.find_all_by_user_type(USER_TYPE)
    unless mailPrivacy.nil?
      mailPrivacy.each do |priv|
        UserMailPrivacy.create( :user => user,
        :mail_privacy => priv,
        :choice => priv.default
        )
      end
    end
  end

  def save_user_privacies privacies
    u_privacies = current_user.user_privacies

    if !u_privacies.empty? and !privacies.nil?
      u_privacies.each do |u_privacy|
        priv = privacies["#{u_privacy.id}"]
        u_privacy[:facebook] = priv.nil? ? false : priv
        u_privacy.save
      end
    elsif privacies.nil?
      u_privacies.each do |u_privacy|
        u_privacy[:facebook] = false
        u_privacy.save
      end
    end
  end

  def save_mail_privacies privacies
    u_privacies = current_user.user_mail_privacies

    if !u_privacies.empty? and !privacies.nil?
      u_privacies.each do |u_privacy|
        priv = privacies["#{u_privacy.id}"]
        u_privacy[:choice] = priv.nil? ? false : priv
        u_privacy.save
      end
    elsif privacies.nil?
      u_privacies.each do |u_privacy|
        u_privacy[:choice] = false
        u_privacy.save
      end
    end
  end

  def userCupons (user)
    #@cupons = Cupon.find_by_user_id(user.id)
    @cupons = user.cupons
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
      session.delete :facebook_client

      soc_link = SocialLink.find_by_social_id_and_social_type(credentials["id"], FacebookAPI.social_type)
      if soc_link.nil?
        #If user is logging from inside de app
        if signed_in?
          if current_user.social_links.empty?
            soc_link = SocialLink.create_from_facebook(session[:facebook_user], current_user) unless session[:facebook_user].nil?

            soc_link[:access_token] = social_link.access_token
            soc_link.save
          end

          FacebookGraph.create_relationships(client, current_user)

        end
      else
        current_user = soc_link.user
        sign_in current_user

        soc_link[:access_token] = social_link.access_token
        soc_link.save
        FacebookGraph.create_relationships(client, current_user)
      end
    rescue
      redirect_to session[:facebook_client].url_for_oauth_code(:callback => FacebookAPI.oauth_callback_url, :permissions => "email, user_status, publish_stream, publish_actions")
      return false
    end
  end

  def check_facebook
    if current_user
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

end

