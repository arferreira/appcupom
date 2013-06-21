class OffersController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_filter :authenticate, :except => [:show, :buy, :explore, :set_distance, :payment_info, :nowon, :near_me, :category, :comments]
  before_filter :correct_user, :except => [:show, :buy, :explore, :set_distance, :payment_info, :nowon, :near_me, :category, :comments]
  before_filter :authenticate_everyone, :only => [:explore, :all, :set_distance, :payment_info, :comments]
  #before_filter :check_for_mobile, :only => [:explore]
  before_filter :require_google, :only => [:show]
  #before_filter :breadcrumbs


  after_filter :clear_keep_offer, :only => [:new, :edit]

  add_breadcrumb 'Ofertas', 'offers_path'
  add_breadcrumb 'Nova oferta', '', :only => [:new, :create]
  add_breadcrumb 'Editar oferta', '', :only => [:edit, :update]

  # GET /offers
  # GET /offers.json
  def index
    @partner = Partner.find(params[:partner_id])
    @offers = @partner.offers

    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true

      format.html # index.html.erb
    end
    #@bc = ["Index",'offers']
    #session[:bc] = @bc
  end

  def nowon
    if params[:get_location]
      @request_location = "true"
      @location_callback = "/offers"
    end
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

    @user_latlong = lat + "|" + long
    session[:user_latlong] = @user_latlong

=begin
    if params[:search]
      @searched_offers = search_offers params[:search]

      #validação da oferta
      @valid_offers = []
      @searched_offers.each do |offer|
        if offer.is_now? and !offer.is_full?
          @valid_offers << offer
        end
      end
      @searched_offers = @valid_offers

      @searched_offers.collect { |item| item[:temp_distance] = (item.distance lat.to_f, long.to_f).round(2) }
    else
=end
      @now_offers = Offer.now_offers session[:city]
      @now_offers.collect { |item| item[:temp_distance] = (item.distance lat.to_f, long.to_f).round(2) }
      @now_offers = @now_offers.paginate(:page => params[:now_offers], :per_page => 5)

      @not_now_offers = Offer.not_now_offers session[:city]
      @not_now_offers.collect { |item| item[:temp_distance] = (item.distance lat.to_f, long.to_f).round(2) }
      @not_now_offers = @not_now_offers.paginate(:page => params[:not_now_offers], :per_page => 5)
    #end

    #@bc = ["Nowon",'offers']
    #session[:bc] = @bc

    respond_to do |format|
      @no_back = true
      @menu = true
      @submenu = true
      @nowon = true
      @offer_list = true
      @search = true

      format.html
      format.js{ render :status => 250}
    end
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
    @gps = session[:gps]

    if @gps
      @user_latlong = session[:user_latlong]
      lat = @user_latlong.split('|')[0]
      long = @user_latlong.split('|')[1]

      @now_offers = Offer.find_now_by_position lat, long, session[:city]
      @now_offers = @now_offers.paginate(:page => params[:now_offers], :per_page => 5)

      @not_now_offers = Offer.find_not_now_by_position lat, long, session[:city]
      @not_now_offers = @not_now_offers.paginate(:page => params[:not_now_offers], :per_page => 5)
    end

    respond_to do |format|
      @no_back = true
      @menu = true
      @submenu = true
      @near_me = true
      @offer_list = true
      @search = true

      if @gps
        format.html
        format.js{ render :status => 250 }
      else
        format.html {redirect_to offers_path(:no_location => true)}
      end
    end
  end

  def category
    @categories = Category.find_with_product session[:city]

    if params[:category] && params[:category] != ""
      category = Category.find params[:category]
    end

    if category.nil?
      @offers = Offer.today_offers session[:city]
    else
      @selected_category = params[:category]
      @offers = Offer.find_by_partner_category session[:city], category.id
    end
    
    @user_latlong = session[:user_latlong]
    lat = @user_latlong.split('|')[0]
    long = @user_latlong.split('|')[1]

    @offers.collect { |item| item[:temp_distance] = (item.distance lat.to_f, long.to_f).round(2) }

    respond_to do |format|
      @no_back = true
      @menu = true
      @submenu = true
      @category = true
      @offer_list = true
      @search = true

      format.html
    end
  end

  def explore
    if params[:gps]
      @gps = params[:gps]
      if params[:gps] == "1"
        lat = params[:lat]
        long = params[:long]
        @request_location = "false"

        @offers = Offer.find_by_position lat, long, session[:city]
      end
    else
      @location_callback = "/explore"
      @request_location = "true"
    end

    respond_to do |format|
      format.html
    end
  end

  def categories
    @offers = Offer.all

    respond_to do |format|
      format.html
    end
  end

  # GET /offers/1s
  # GET /offers/1.json
  def show
    @offer = Offer.find(params[:id])
    @partner = @offer.partner
    #@rules = Rule.find_all_by_offer_type @offer.ttype[0]
    @rules = Rule.find_by_sql(["SELECT r.*
      FROM rules r, offer_rules of
      WHERE r.id = of.rule_id
      AND of.offer_id = :oid
      AND value > 0
      AND offer_type = :otp", {:oid => @offer.id, :otp => @offer.ttype[0]}])
    @products = @offer.products

    @location_callback = "/partners/#{@partner.id}/set_distance"
    @cached_location = "true"

    if current_user
      if current_user.access_type == USER_TYPE
        @current_user = current_user
      elsif current_user.access_type == PARTNER_TYPE && current_user?(@partner)
        @partner_user = @partner
      end
    end

    @recommend_partners = @partner.recommend_partners
    @recommend_partners_count = @recommend_partners.size
    #TODO fazer recommend offer
    @recommend_products = RecommendProduct.by_offer @offer
    @recommend_products_count = @recommend_products.size
    @wish_products = WishProduct.by_offer @offer
    @wish_products_count = @wish_products.size

    add_breadcrumb @partner.name, "offers/#{@offer.id}"

    respond_to do |format|
      @title = @partner.company_name
      @menu = true
      @submenu = false
      @share_cupon = true
      @offer_show_back = @offer

      format.html # show.html.erb
    end

  end

  def payment_info
    @offer = Offer.find(params[:id])
    @partner = @offer.partner
    @title = "Detalhes da Compra"
    moip_error = false

    if current_user.access_type == USER_TYPE
      @current_user = current_user
      @user_credits = @current_user.active_credits

      @credit_value = @offer.avaliable_credit_value @current_user.total_credit_value
      @nowon_value = @offer.nowon_value @current_user.total_credit_value

      if !@current_user.card.nil? && @current_user.card.save_card && @current_user.card.has_key? && @nowon_value != 0
        user_card = current_user.card
        @user_card = user_card
        @show_payment_fields = false

        unique_key = "Now#{rand(1000)}"
        moip_return = @current_user.pay_cupon @offer, user_card, unique_key

        unless moip_return.nil?
          @token = moip_return[:transaction_token]

          @transaction_id = moip_return[:id]
          @cupon = Cupon.create  :user_id => current_user.id,
          :offer_id => @offer.id ,
          :price => @offer.nowon_value(@current_user.total_credit_value),
          :credit_discount => @offer.avaliable_credit_value(@current_user.total_credit_value),
          :good_date => Time.now,
          :cupon_code => "",
          :monthly_cupon_accounting_id => 0,
          :transaction_id => @transaction_id,
          :nasp_key => unique_key,
          :approved => false

          @user_birthdate = user_card[:birthdate]
          @user_cpf = user_card[:cpf]
        else
          moip_error = true
        end
      end

    else
      @current_user = nil
    end

    add_breadcrumb "Comprar", "offers/#{@offer.id}/payment_info"

    
    respond_to do |format|
      if moip_error
        flash[:notice] = "O contato com o Moip foi falhou, tente novamente.";
        format.html {redirect_to :controller => "offers", :action => "show", :offer_id => @offer.id}
      else
        @menu = true
        @submenu = false
        require_moip
        
        format.html# payment_info.html.erb
      end


    end
  end


  def set_distance
    partner = Partner.find params[:partner_id]
    if params[:gps] == 1
      lat = params[:lat]
      long = params[:long]
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

    if lat.nil? || long.nil?
      @distance = 0
      @user_latlong = "0|0"
    else
      dist = partner.geo_distance lat.to_f, long.to_f
      @distance = dist.round(2) unless dist.nil?
      @user_latlong = lat + "|" + long
    end

    respond_to do |format|
      format.js {render :status => 250}
    end
  end


  # GET /offers/new
  # GET /offers/new.json
  def new
    @offer = Offer.new
    @offer[:cupon_counter] = 10
    session.delete :keep_rule

    @offer.attributes = @offer.attributes.except("id", "active", "created_at", "updated_at").merge( session[:keep_offer][:offer] ) unless session[:keep_offer].nil?
    @partner = Partner.find(params[:partner_id])
    @products = Product.find_all_by_partner_id_and_active(@partner.id, true)  # @partner.products

    @days = session[:keep_offer].nil? ? "0000000".split(//) : selected_days_to_days_array( session[:keep_offer][:selected_days] ).split(//)
    @products_rules = Rule.find_all_by_offer_type(PRODUCT_RULE)
    @credit_rules = Rule.find_all_by_offer_type(CREDIT_RULE)

    @pics_list =  params[:selected_pics] || get_from_session(:selected_pics)
    @pics = PartnerPic.find @pics_list unless @pics_list.nil?

    @offer[:discount] = get_from_session(:discount) || params[:discount]
    @prods_list = get_from_session(:selected_products) || params[:selected_products]
    unless @prods_list.nil?
      if @prods_list.nil? ||  @prods_list.size == 0
        @existing_products = @offer.products
        @prods_list = @existing_products.collect(&:id)
      else
        @existing_products = Product.find(@prods_list.split(","), :order => "field(id,#{@prods_list})")
      end

      @offer_value = @offer.price * (1 - INITIAL_DISCOUNT/100.0)
      @offer[:price] = @offer_value
      @partner_value = @offer_value * (1 - @partner.system_profit/100.0 )
      @nowon_value = @offer_value * (@partner.system_profit/100.0 )
    end
    @original_price = get_from_session(:original_price) || 0

    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true

      format.html # new.html.erb
    end
  end

  # GET /offers/1/edit
  def edit
    @offer = Offer.find(params[:id])

    unless @offer.nil?
      session.delete :keep_rule
      @offer.attributes = @offer.attributes.except("id", "active", "created_at", "updated_at").merge( session[:keep_offer][:offer] ) unless session[:keep_offer].nil?
      @partner = @offer.partner
      @products = Product.find_all_by_partner_id_and_active(@partner.id, true) #@partner.products
      @original_price = get_from_session(:original_price) || @offer.original_price

      @days = session[:keep_offer].nil? ? @offer.recurrence.split(//) : selected_days_to_days_array( session[:keep_offer][:selected_days] ).split(//)
      @products_rules = Rule.find_all_by_offer_type(PRODUCT_RULE)
      @credit_rules = Rule.find_all_by_offer_type(CREDIT_RULE)

      @pics_list = get_from_session(:selected_pics) || params[:selected_pics]
      @pics = PartnerPic.find @pics_list unless @pics_list.nil?
      @pics ||= @offer.pic1

      if @offer.is_product_offer?
        @prods_list = get_from_session(:selected_products) || params[:selected_products]
        if @prods_list.nil? ||  @prods_list.size == 0
          @existing_products = @offer.products
          @prods_list = @existing_products.collect(&:id)
        else
          @existing_products = Product.find(@prods_list.split(","), :order => "field(id,#{@prods_list})")
        end

        unless @prods_list.nil? || @prods_list.empty?
          @offer_value = @offer.price * (1 - @offer.discount/100.0)
          @offer[:price] = @offer_value
          @partner_value = @offer_value * (1 - @partner.system_profit/100.0 )
          @nowon_value = @offer_value * (@partner.system_profit/100.0 )
        end
      end

      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true

    end
  end

  # POST /offers
  # POST /offers.json
  def create
    params[:offer][:recurrence] = selected_days_to_days_array(params[:selected_days])
    add_pics params[:offer], params[:selected_pics]

    d('Params>>>>>>>>>>', params)

    @offer = Offer.new(params[:offer])
    @partner = Partner.find(params[:partner_id])
    @days = session[:keep_offer].nil? ? @offer.recurrence.split(//) : selected_days_to_days_array( session[:keep_offer][:selected_days] ).split(//)
    @products_rules = Rule.find_all_by_offer_type(PRODUCT_RULE)
    @credit_rules = Rule.find_all_by_offer_type(CREDIT_RULE)
    @products = Product.find_all_by_partner_id_and_active(@partner.id, true)

    return if check_form_submit @partner, @offer

    @offer.main_pic = params[:main_pic]
    @offer.daily_cupons = @offer[:cupon_counter]
    @original_price = params[:original_price].gsub(",", ".").to_f
    @offer.city_id = @partner.city_id

    @offer.discount = params[:discount]
    @offer.original_price = @original_price
    @offer.paused = 0
    @pics_list =  params[:selected_pics] || get_from_session(:selected_pics)
    @pics = PartnerPic.find @pics_list if !@pics_list.nil? && @pics_list != ""

    @offer.company_name = @partner.company_name

    d('offer discount after', @offer.discount)

    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true

      d('Controller Offer', @offer)

      if @offer.save &&
        (@offer.is_credit_offer? ||
          (@offer.is_product_offer? && add_products(@offer, params[:selected_products].split(","),
            params[:selected_products_qty].split(",")) ))

        OfferRule.createOrUpdateOfferRuleByOffer @offer, params

        format.html {
          flash[:notice] = 'Oferta criada com sucesso.'
          redirect_to partner_offers_path @partner 
        }
      else
        if @offer.is_product_offer?
          @prods_list = params[:selected_products]
          if @prods_list.nil? ||  @prods_list.size == 0
            @existing_products = @offer.products
            @prods_list = @existing_products.collect(&:id)
          else
            @existing_products = Product.find(@prods_list.split(","), :order => "field(id,#{@prods_list})")
          end

          unless @prods_list.nil? || @prods_list.empty?
            @offer_value = @offer.price * (1 - @offer.discount/100.0)
            @offer[:price] = @offer_value
            @partner_value = @offer_value * (1 - @partner.system_profit/100.0 )
            @nowon_value = @offer_value * (@partner.system_profit/100.0 )
          end

          offer_rules = @products_rules
        else
          offer_rules = @credit_rules
        end

        session[:keep_rule] = {}
        offer_rules.each do |rule|
          session[:keep_rule]["edit_rule_#{rule.id}"] = params["rule_#{rule.id}"]
        end

        format.html { render action: "new" }
      end
    end
  end

  # PUT /offers/1
  # PUT /offers/1.json
  def update
    @offer = Offer.find(params[:id])

    @partner = @offer.partner
    @days = session[:keep_offer].nil? ? @offer.recurrence.split(//) : selected_days_to_days_array( session[:keep_offer][:selected_days] ).split(//)
    @products_rules = Rule.find_all_by_offer_type(PRODUCT_RULE)
    @credit_rules = Rule.find_all_by_offer_type(CREDIT_RULE)
    @products = Product.find_all_by_partner_id_and_active(@partner.id, true) #@partner.products

    return if check_form_submit @partner, @offer

    params[:offer][:recurrence] = selected_days_to_days_array(params[:selected_days])
    OfferRule.createOrUpdateOfferRuleByOffer @offer, params

    @offer.main_pic = params[:main_pic]
    add_pics params[:offer], params[:selected_pics]
    @original_price = params[:original_price].gsub(",", ".").to_f
    @pics_list =  params[:selected_pics] || get_from_session(:selected_pics)
    @pics = PartnerPic.find @pics_list if !@pics_list.nil? && @pics_list != ""
    @pics ||= @offer.pic1

    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true

      params[:offer][:original_price] = @original_price
      params[:offer][:discount] = params[:discount]
      params[:offer][:daily_cupons] = params[:offer][:cupon_counter]

      if @offer.update_attributes(params[:offer]) &&
        (@offer.is_credit_offer? ||
          (@offer.is_product_offer? && add_products(@offer, params[:selected_products].split(","),
            params[:selected_products_qty].split(",")) ))

        format.html { redirect_to partner_offers_path @partner, notice: 'Oferta atualizada com sucesso.' }
      else
        if @offer.is_product_offer?
          @prods_list = get_from_session(:selected_products) || params[:selected_products]
          if @prods_list.nil? ||  @prods_list.size == 0
            @existing_products = @offer.products
            @prods_list = @existing_products.collect(&:id)
          else
            @existing_products = Product.find(@prods_list.split(","), :order => "field(id,#{@prods_list})")
          end

          unless @prods_list.nil? || @prods_list.empty?
            @offer_value = @offer.price * (1 - @offer.discount/100.0)
            @offer[:price] = @offer_value
            @partner_value = @offer_value * (1 - @partner.system_profit/100.0 )
            @nowon_value = @offer_value * (@partner.system_profit/100.0 )
          end

          offer_rules = @products_rules
        else
          offer_rules = @credit_rules
        end

        session[:keep_rule] = {}
        offer_rules.each do |rule|
          session[:keep_rule]["edit_rule_#{rule.id}"] = params["rule_#{rule.id}"]
        end

        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /offers/1
  # DELETE /offers/1.json
  def destroy
    @offer = Offer.find(params[:id])
    @offer.update_attributes({:deleted => 1})

    respond_to do |format|
      format.html { redirect_to offers_url }
    end
  end

  def stop
    @offer = Offer.find(params[:offer_id])

    @offer.active = false
    @offer.save

    @partner = Partner.find(params[:partner_id])

    respond_to do |format|
      format.html { redirect_to partner_offers_path }
    end
  end

  def pause
    @offer = Offer.find(params[:offer_id])

    @offer.paused = true
    @partner = Partner.find(params[:partner_id])

    respond_to do |format|
      if @offer.save
        format.html { redirect_to "/partners/#{@partner.id}/dashboard", :notice => "Oferta Interrompida por hoje." }
      else
        format.html { redirect_to "/partners/#{@partner.id}/dashboard", :notice => "Erro ao interromper oferta." }
      end
    end
  end

  def restart
    @offer = Offer.find(params[:offer_id])

    @offer.paused = false
    @partner = Partner.find(params[:partner_id])

    respond_to do |format|
      if @offer.save
        format.html { redirect_to "/partners/#{@partner.id}/dashboard", :notice => "Oferta iniciada para hoje." }
      else
        format.html { redirect_to "/partners/#{@partner.id}/dashboard", :notice => "Erro ao iniciar oferta." }
      end
    end
  end

  def start
    @offer = Offer.find(params[:offer_id])
    @offer.active = true
    # @offer.start_date = Time.now.in_time_zone.beginning_of_day unless Time.now.in_time_zone.beginning_of_day <= @offer.start_date
    @offer.save
    @partner = Partner.find(params[:partner_id])

    respond_to do |format|
      format.html { redirect_to partner_offers_path }
    end
  end

  # /partners/1/offers/1/select_images
  # /partners/1/offers/select_images
  def select_images
    @partner = Partner.find(params[:partner_id])
    if params[:id] == "-1"
      @offer = nil
    else
      @offer = Offer.find(params[:id])
    end

    @select_callback = url_for( @offer.nil? ? new_partner_offer_path(@partner) : [:edit, @partner, @offer] )
    @partner_pics = @partner.partner_pics #PartnerPic.find_all_by_partner_id_and_pic_type(params[:partner_id], 'O')

    @num_select = PICS_PER_OFFER

    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true

      format.html { render :template => "partner_pics/index"}
    end
  end

  def select_products
    @partner = Partner.find(params[:partner_id])
    if params[:id] == "-1"
      @offer = nil
    else
      @offer = Offer.find(params[:id])
    end

    @select_callback = url_for( @offer.nil? ? new_partner_offer_path(@partner) : [:edit, @partner, @offer] )
    @products = @partner.active_products
    @num_select = PRODS_PER_OFFER

    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true

      format.html { render :template => "products/select"}
    end
  end

  private

  def authenticate
    deny_access unless signed_in? PARTNER_TYPE
  end

  def authenticate_everyone
    deny_access unless (signed_in? USER_TYPE) || (signed_in? PARTNER_TYPE) || (signed_in? ADMIN_TYPE)
  end

  def correct_user
    @partner = Partner.find(params[:partner_id])
    redirect_to(root_path, :notice => "Access Denied" )unless current_user?(@partner)
  end

  #transform ["1", "2", "7"] in "1100001"
  def selected_days_to_days_array selected_days
    days_array = '0000000'.split(//)

    days_array.each_with_index do |day, index|
      if !selected_days.nil? && selected_days.include?( (index+1).to_s )
        days_array[index] = '1'
      end
    end
    days_array.join
  end

  def check_form_submit partner, offer
    d("Selected Prods" + params[:selected_products_qty])

    if params[:select_pics]
      session[:keep_offer] = params
      session[:keep_offer][:selected_products] = params[:selected_products] unless params[:selected_products].nil?
      redirect_to "/partners/#{@partner.id}/offers/#{@offer.id.nil? ? -1 : @offer.id}/select_images"
      return true;
    elsif params[:select_prods]
      session[:keep_offer] = params
      session[:keep_offer][:selected_pics] = params[:selected_pics] unless params[:selected_pics].nil?
      redirect_to "/partners/#{@partner.id}/offers/#{@offer.id.nil? ? -1 : @offer.id}/select_products"
      return true;
    else

    end
  end

  def clear_keep_offer
    session.delete(:keep_offer)
  end

  def add_pics offer_hash, selected_pics_hash
    unless selected_pics_hash.nil? || selected_pics_hash.empty?
      selected_pics = selected_pics_hash.split(",")
      unless selected_pics.length == 0 && selected_pics.length > PICS_PER_OFFER
        for i in 1..PICS_PER_OFFER
          if selected_pics.empty?
            offer_hash["partner_pic#{i}_id"] = nil
          else
            offer_hash["partner_pic#{i}_id"] = selected_pics.pop
          end
        end
      end
    end
    offer_hash
  end

  def get_from_session session_name
    out = nil
    unless session[:keep_offer].nil?
      unless session[:keep_offer][session_name].nil? || session[:keep_offer][session_name] == ""
        out = session[:keep_offer][session_name]
      end
    end
    out
  end

  def add_products offer, products_list, products_qty_list
    if offer.ttype == PRODUCT_OFFER
      offer.destroy_offer_products
      offer.add_offer_products( products_list, products_qty_list )
    else
      true
    end
  end

  def search_offers text
    search = Offer.search do
      fulltext text do
        highlight :description
      end
    end
    #search = Sunspot.search Offer, Partner
    #search = Sunspot.search(Offer, Partner) do
     # fulltext text do
     #   fields(:description, :company_name)
    #  end
    #end

    return search.results
  end

  def breadcrumbs
    @bc = Array.new unless @bc != nil
    #@bc = session[:bc] unless session[:bc] == nil
    d('in breadcrumbs',@bc)
  end

end
