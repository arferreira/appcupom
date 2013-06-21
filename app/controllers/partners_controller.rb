# encoding: utf-8
class PartnersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :destroy]
  before_filter :authenticate_admin, :only => [:new]
  before_filter :correct_user, :only => [:edit, :update, :destroy, :dashboard]
  before_filter :partner_edit, :only => :edit
  before_filter :get_facilities, :get_recommendations, :except => :destroy
  before_filter :require_google, :only => [:show, :dashboard, :recommend, :unrecommend]
  #before_filter :check_for_mobile, :only => [:show]
  
  # GET /partners
  # GET /partners.json
  def index
    if params[:gps] == "1"
      lat = params[:lat]
      long = params[:long]

      session[:location_time] = Time.now
      session[:gps] = 1

      city = City.find_by_name(params[:city])
      session[:city] = city.id unless city.nil?
      @gps = session[:gps]
    else
      if params[:city_id]
        @gps = nil
        session[:city] = params[:city_id]
        city = City.find params[:city_id]
        city ||= City.first

        lat = city.latitude.to_s
        long = city.longitude.to_s
      else
        @gps = session[:gps]
        if session[:user_latlong]
          user_latlong = session[:user_latlong]
          lat = user_latlong.split('|')[0]
          long = user_latlong.split('|')[1]
        else
          city = City.first
          lat = city.latitude.to_s
          long = city.longitude.to_s
        end
      end
    end
    if params[:get_location]
      @request_location = "true"
      @location_callback = "/offers"
    end

    if session[:city]
      @partners = Partner.find_local session[:city]
    else
      @partners = Partner.where(:approved => 1)
    end

    if params[:search]
      @partners = search_partners @partners, params[:search]
    else
      @partners = @partners.page(params[:page]).per_page(5)
    end
    
    @user_latlong = session[:user_latlong]
    unless @user_latlong.nil?
      lat = @user_latlong.split('|')[0]
      long = @user_latlong.split('|')[1]
      @partners.collect { |item| item[:temp_distance] = (item.geo_distance lat.to_f, long.to_f).round(2) }
    end
    
    add_breadcrumb "Explorar", "partners"

    respond_to do |format|
      @title = "Explorar"
      @no_back = true
      @menu = true
      @submenu = true
      @explore = true
      @pop = true
      @partner_list = true
      @search = true

      format.html # index.html.erb
      format.js # index.js.erb
    end
  end

  def index_posts
    if params[:gps] == "1"
      lat = params[:lat]
      long = params[:long]

      session[:location_time] = Time.now
      session[:gps] = 1

      city = City.find_by_name(params[:city])
      session[:city] = city.id unless city.nil?
      @gps = session[:gps]
    else
      if params[:city_id]
        @gps = nil
        session[:city] = params[:city_id]
        city = City.find params[:city_id]
        city ||= City.first

        lat = city.latitude.to_s
        long = city.longitude.to_s
      else
        @gps = session[:gps]
        if session[:user_latlong]
          user_latlong = session[:user_latlong]
          lat = user_latlong.split('|')[0]
          long = user_latlong.split('|')[1]
        else
          city = City.first
          lat = city.latitude.to_s
          long = city.longitude.to_s
        end
      end
    end
    redirect_to "/partners"
  end
  
  def near_me
    if params[:gps] == "1"
      lat = params[:lat]
      long = params[:long]

      session[:location_time] = Time.now
      session[:gps] = 1

      city = City.find_by_name(params[:city])
      session[:city] = city.id unless city.nil?
      @gps = session[:gps]
    else
      if params[:city_id]
        @gps = nil
        session[:city] = params[:city_id]
        city = City.find params[:city_id]
        city ||= City.first

        lat = city.latitude.to_s
        long = city.longitude.to_s
      else
        @gps = session[:gps]
        if session[:user_latlong]
          user_latlong = session[:user_latlong]
          lat = user_latlong.split('|')[0]
          long = user_latlong.split('|')[1]
        else
          city = City.first
          lat = city.latitude.to_s
          long = city.longitude.to_s
        end
      end
    end

    @user_latlong = session[:user_latlong]
    @gps = session[:gps]
    if @user_latlong && @gps
      lat = @user_latlong.split('|')[0]
      long = @user_latlong.split('|')[1]

      if session[:city]
        @partners = Partner.find_by_position_from_city lat, long, session[:city]  
      else
        @partners = Partner.find_by_position lat, long
      end

      if params[:search]
        @partners = search_partners @partners, params[:search]
      else
        @partners = @partners.page(params[:page]).per_page(5)
      end
      
      @partners.collect { |item| item[:temp_distance] = (item.geo_distance lat.to_f, long.to_f).round(2) }
      
      add_breadcrumb "Explorar", "partners_near_me_path"
      
      respond_to do |format|
        @title = "Explorar"
        @no_back = true
        @menu = true
        @submenu = true
        @explore = true
        @near_me = true
        @partner_list = true

        format.html { render 'index'}
      format.js { render 'index', :status => 250}
      end
    else
      redirect_to partners_path(:no_location => true)
    end
  end
  
  def category
    @categories = Category.find_with_partner session[:city]
    
    if params[:category] && params[:category] != ""
      category = Category.find params[:category]
      session[:category] = category.id
    end
    
    if session[:city]
      @partners = Partner.find_local session[:city] 
    else
      @partners = Partner.where(:approved => 1)
    end
    
    if params[:category] == ""
      session[:category] = ""
    elsif !category.nil?
      @partners = Partner.find_local_with_category session[:city], category.id
      @selected_category = session[:category]
    end

    if params[:search]
      @partners = search_partners @partners, params[:search]
    else
      @partners = @partners.page(params[:page]).per_page(5)
    end
    
    @user_latlong = session[:user_latlong]
    unless @user_latlong.nil?
      lat = @user_latlong.split('|')[0]
      long = @user_latlong.split('|')[1]
      @partners.collect { |item| item[:temp_distance] = (item.geo_distance lat.to_f, long.to_f).round(2) }
    end

    
    add_breadcrumb "Explorar", "partners_category_path"

    respond_to do |format|
      @title = "Explorar"
      @no_back = true
      @menu = true
      @submenu = true
      @category = true
      @partner_list = true
      @search = true
      
      format.html
      format.js
    end
  end

  # GET /partners/1
  # GET /partners/1.json
  def show
    @partner = Partner.find(params[:id])
    @offers = @partner.today_offers
    #@product_types = ProductType.find_all_by_partner_id_and_active(@partner.id, true)    
    @product_types = ProductType.order("id").page(params[:page]).per_page(3).find_all_by_partner_id_and_active(@partner.id, true) 
    
    #if (current_user)
      #@recommenders = RecommendPartner.find_by_friendship(params[:id], current_user.id)
   # else
   @recommenders = RecommendPartner.find_all_by_partner_id(params[:id])
    #end
    
    @recommend_partners = @partner.recommend_partners
    @num_parecs = @recommend_partners.count
    @recommend_products = RecommendProduct.find_all_by_product_id(Product.find_all_by_partner_id(params[:id])) 
    @num_porecs = @recommend_products.count
    @product_wishes = WishProduct.find_all_by_product_id(Product.find_all_by_partner_id(params[:id]))
    @num_powish = @product_wishes.count
    
    @location_callback = "/partners/#{@partner.id}/set_distance"
    @cached_location = "true"
    
    @partner_partner_pics = PartnerPic.find_all_by_partner_id_and_pic_type(params[:id], 'P')
    
    add_breadcrumb @partner.company_name, "partners/#{@partner.id}"

      #  if @partner.approved || !NEEDS_APPROVAL
      respond_to do |format|
        @title = @partner.company_name
        @menu = true
        @partner_show_back = @partner

        format.html # show.html.erb
        format.js {render :status => 250}# show.js.erb
        format.json { render json: @partner }
      end
    end

    def set_distance
      partner = Partner.find params[:partner_id]
      lat = params[:lat]
      long = params[:long]

      dist = partner.geo_distance lat.to_f, long.to_f
      @distance = dist.round(2) unless dist.nil?
      @user_latlong = lat + "|" + long

      @debug = "teste"

      respond_to do |format|
        format.js {render :status => 250}
      end
    end

  # GET /partners/new
  # GET /partners/new.json
  def new
    @partner = Partner.new
    
    #integration
    @fac_count = 0

    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true
      
      format.html # new.html.erb
      format.json { render json: @partner }
    end
  end

  # GET /partners/1/edit
  def edit
    #@partner = current_user
    @partner = Partner.find(params[:id])
    @partner_script_and_css = true
    @no_top_tool = true
    @partner_menu = true
    
    add_breadcrumb "Editar", "partners/#{@partner.id}/edit"
  end

  # POST /partners
  # POST /partners.json
  def create
    if params[:partner] && params[:partner][:system_profit].nil?
      params[:partner][:system_profit] = PROFIT      
    end
    @partner = Partner.new(params[:partner])
    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true
      
      if @partner.save
        sign_in @partner
        format.html { redirect_to @partner, notice: 'Parceiro criado com sucesso.' }
        format.json { render json: @partner, status: :created, location: @partner }
      else
        format.html { render action: "new" }
        format.json { render json: @partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /partners/1
  # PUT /partners/1.json
  def update
    @partner = Partner.find(params[:id])
    
    #d('UPDATE PARTNER, Params', params[:id], 'Partner', @partner)
    
    d('Params payment_option_ids', params[:payment_option_ids])
    
    d('Params facilitiesss', params[:partner][:facility_ids])
    
   # p params[:payment_option_ids]

   # p params[:partner[:facility_ids]]
   add_breadcrumb "Editar", "partners/#{@partner.id}/edit"

   respond_to do |format|
    @partner_script_and_css = true
    @no_top_tool = true
    @partner_menu = true

    if @partner.update_attributes(params[:partner])
      format.html { redirect_to edit_partner_path @partner, notice: 'Partner editado com sucesso.' }
      format.json { head :no_content }
    else
      format.html { render action: "edit" }
      format.json { render json: @partner.errors, status: :unprocessable_entity }
    end
  end
end

  # DELETE /partners/1
  # DELETE /partners/1.json
  def destroy
    @partner = Partner.find(params[:id])
    
    @partner.active = 0
    @partner.approved = 0
    @partner.email = "partner#{@partner.id}@nowon.inactive"

    #@partner.save
    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true
      
      if @partner.save
        #sign_out
        format.html { redirect_to partners_url, notice: 'Parceiro DESATIVADO com sucesso!' }
        format.json { head :no_content }
      else
        format.html { redirect_to root_path, notice: 'FAIL' }
      end
    end
  end

  # GET /wating_approval
  # GET /wating_approval.json
  def waiting_approval
    respond_to do |format|
      format.html # wating_approval.html.erb
    end
  end

  # GET /partners/1/dashboard
  # GET /partners/1/dashboard.json
  def dashboard
    if params[:id] != nil
      @partner = Partner.find(params[:id])
    else
      deny_access
    end
    
    @today_offers = @partner.all_today_offers
    @week_offers = @partner.week_offers
    @cupons = @partner.today_cupons
    
    @offers_count = @partner.offers.count
    @cupons_count = @partner.cupons_count
    @offers_rec_count = @partner.offers_rec_count
    @partner_rec_count = @partner.recommend_partners.count
    @products_count = @partner.products.count
    @products_rec_count = @partner.products_rec_count
    
    #uncomment to allow partner aprovement
    #if !@partner.approved?
    #  @partner_script_and_css = true
    #  @no_top_tool = true
    #  @partner_menu = true
    #  respond_to do |format|
    #    format.html # dashboard.html.erb
    #  end
    #else
    #  waiting_approval
    #end
    
    add_breadcrumb "Painel", "partners/#{@partner.id}/dashboard"
    
    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true
      
      format.html # dashboard.html.erb
    end
  end
  
  #Sprint002
  def recommend
    @partner = Partner.find(params[:id])
    @user = current_user
    
    @recommend = Recommend.new
    @recommend.user = @user
    @recommend.partner = @partner
    
    respond_to do |format|
      if @recommend.save
        format.html { redirect_to partner_path, notice: 'Recomendado com Sucesso!' }
      else
        format.html { redirect_to partner_path, notice: 'Erro! Não foi recomendado.' }
      end
    end
  end
  
  def unrecommend
    @partner = Partner.find(params[:id])
    @user = current_user
    
    @recommend = Recommend.new
    @recommend.user = @user
    @recommend.partner = @partner
    
    respond_to do |format|
      if @recommend.save
        format.html { redirect_to partner_path, notice: 'Recomendado com Sucesso!' }
      else
        format.html { redirect_to partner_path, notice: 'Erro! Não foi recomendado.' }
      end
    end
  end
  #end Sprint002
  
  def approve
    @partner = Partner.find(params[:id])
    @source = params[:source]
    if signed_in? ADMIN_TYPE
      @admin = current_user
    else
      @admin = nil
    end
    
    if @admin != nil
      @partner.approve(@admin)
    end
    
    if @partner.save!
      if @source == 'pshow'
        redirect_to partner_path, notice: "Parceiro #{@partner.company_name} aprovado com sucesso!"
      elsif @source == 'ppp'
        redirect_to aprovar_path, notice: "Parceiro #{@partner.company_name} aprovado com sucesso!"
      elsif @source == 'lp'
        redirect_to listar_parceiros_path, notice: "Parceiro #{@partner.company_name} aprovado com sucesso!"
      end
    else
      if @source == 'pshow'
        redirect_to partner_path, notice: 'Permissão negada!'
      elsif @source == 'ppp'
        redirect_to aprovar_path, notice: 'Permissão negada!'
      elsif @source == 'lp'
        redirect_to listar_parceiros_path, notice: 'Permissão negada!'
      end
    end
    
  end
  
  def deactivate
    @partner = Partner.find(params[:id])
    
    if signed_in? ADMIN_TYPE
      @change = true
      @partner.active = false
      @partner.approved = false
    else
      @change = false
    end
    
    if @partner.save! and @change
      redirect_to listar_parceiros_path, notice: "Parceiro #{@partner.company_name} desativado com sucesso!"
    else
      redirect_to listar_parceiros_path, notice: 'Permissão negada!'
    end
    
  end

  
  private

  def authenticate
    deny_access unless signed_in? PARTNER_TYPE or signed_in? ADMIN_TYPE
  end
  
  def authenticate_admin
    deny_access_admin unless signed_in? ADMIN_TYPE
  end
  
  def correct_user
    if params[:id] != nil
      if (!signed_in? ADMIN_TYPE)
        @partner = Partner.find(params[:id])
        redirect_to(root_path, :notice => "Access Denied" )unless current_user?(@partner)
      end
    else
      redirect_to "/p/signin"
    end
  end
  
  def partner_edit
    @partner = Partner.find(params[:id])
    redirect_to(root_path, :notice => "Access Denied" )unless current_user?(@partner)
  end
  
  def get_facilities
    @facilities = Facility.all
  end
  
  def get_recommendations
    @recommendations = Recommendation.all
  end

  def search_partners partners_list, search_string
    list = Partner.search do
      with(:id).any_of(partners_list.map(&:id))
      fulltext search_string do
        highlight(:company_name, :address, :description)
      end
    end
    list.results
  end
  
end
