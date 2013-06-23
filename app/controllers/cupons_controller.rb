# encoding: utf-8
class CuponsController < ApplicationController
  before_filter :authenticate,          :except => [:confirmation,:receive_key, :validate_cupons,:validate]
  before_filter :correct_user,          :except => [:confirmation,:receive_key, :validate_cupons,:validate,:share_cupon, :confirm_printed]
  before_filter :authenticate_partner,  :only => [:validate_cupons,:validate]
  before_filter :correct_partner,       :only => [:validate_cupons,:validate]
  before_filter :require_moip,          :only => [:buy, :buy_cupon, :confirmation, :receive_key]


  def index
    @user = User.find(params[:user_id])
    @cupons_list = Cupon.find_on_time @user.id

    unless @cupons_list.empty?
      p '    -    '
      p '    -    '
      p '    -    '
      p '    -    '
      p @cupons_list
      p @cupons_list.first.offer.partner.company_name.to_s
      p '    -    '
      p '    -    '
      p '    -    '
      p '    -    '
    end

    add_breadcrumb "Compras", "users/#{@user.id}/cupons"

    respond_to do |format|
      @title = "Compras"
      @no_back = true
      @menu = true
      @submenu = true
      @credit = true
      @actual = true

      format.html # index.html.erb
    end
  end

  def old_ones
    @user = User.find(params[:user_id])
    @cupons_list = Cupon.find_old_ones @user.id

    add_breadcrumb "Compras", "users/#{@user.id}/cupons"

    respond_to do |format|
      @title = "Histórico de Compras"
      @no_back = true
      @menu = true
      @submenu = true
      @credit = true
      @old = true

      format.html { render "index"}
    end
  end

  def show
  end

  #Show payment options
  def buy
    @current_user = current_user
    @offer = Offer.find params[:offer_id]
    @partner = @offer.partner
    @card_flags = CardFlag.all
    @offer_show_back = true
    @title = "Confirme seus dados"
    @moip_error = false

    user_cards = current_user.cards

    @user_credits = @current_user.active_credits
    @credit_value = @offer.avaliable_credit_value @current_user.total_credit_value
    @nowon_value = @offer.nowon_value @current_user.total_credit_value
    if user_cards.empty?
      @show_payment_fields = true
    else
      user_card = current_user.card
      @show_payment_fields = false
      dt = DateTime.now.to_i
      unique_key = "Now#{Random.new(dt.hash + current_user.hash).rand(10000)}"
      puts "INICIO==============================================UNIQUE_KEY"
      puts unique_key
      puts "FIM=================================================UNIQUE_KEY"
      moip_return = @current_user.pay_cupon @offer, user_card, unique_key

      if !moip_return.nil? && !moip_return[:transaction_token].nil? && moip_return[:transaction_token] != ""
        @token = moip_return[:transaction_token]
        @user_card = user_cards[0]
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
                                 :approved => false,
                                 :moip_status => "Iniciado"

        @user_birthdate = user_card[:birthdate]
        @user_cpf = user_card[:cpf]
      else
        @moip_error = true
      end

    end

    respond_to do |format|
      if @moip_error
        flash[:notice] = "O contato com o Moip foi falhou, tente novamente.";
        format.html {redirect_to :controller => "offers", :action => "payment_info", :offer_id => @offer.id}
      else
        @menu = true
        @submenu = false
        format.html
      end
    end
  end

  def buy_cupon
    @current_user = current_user
    @offer = Offer.find params[:offer_id]

    #resumo
    @user_credits = @current_user.active_credits
    @credit_value = @offer.avaliable_credit_value @current_user.total_credit_value
    @nowon_value = @offer.nowon_value @current_user.total_credit_value

    dt = DateTime.now.to_i
    unique_key = "Now#{Random.new(dt.hash + current_user.hash).rand(10000)}"
    puts "INICIO==============================================UNIQUE_KEY"
    puts unique_key
    puts "FIM=================================================UNIQUE_KEY"

    moip_return = @current_user.pay_cupon @offer, params, unique_key
    d(moip_return)
    if !moip_return.nil? && !moip_return[:transaction_token].nil? && moip_return[:transaction_token] != ""
      @token = moip_return[:transaction_token]
      @current_user.create_user_card params
      @transaction_id = moip_return[:id]
      @user_card_name = params[:name]
      @user_birthdate = params[:DataNascimento]
      @user_cpf = params[:Identidade]
      @cupon = Cupon.create  :user_id => current_user.id,
                             :offer_id => @offer.id,
                             :price => @offer.nowon_value(@current_user.total_credit_value),
                             :credit_discount => @offer.avaliable_credit_value(@current_user.total_credit_value),
                             :good_date => Time.now,
                             :cupon_code => "",
                             :monthly_cupon_accounting_id => 0,
                             :transaction_id => @transaction_id,
                             :nasp_key => unique_key,
                             :approved => false,
                             :moip_status => "Iniciado"

    else
      @moip_error = true
      @moip_return = moip_return
    end

    respond_to do |format|
      if @moip_error
        flash[:notice] = "O contato com o Moip foi falhou, tente novamente.";
        format.html {redirect_to :controller => "offers", :action => "payment_info", :offer_id => @offer.id}
      else
        format.js {render :status => 250}
      end
    end
  end

  def confirmation
    @cupon = Cupon.find params[:id]
    user = @cupon.user

    if !@cupon[:approved] && @cupon[:transaction_id] == params[:transaction_id]
      status = params[:status]
      @cupon[:moip_status] = status
      @cupon[:approved] = (status == "Autorizado" || status == "Concluido")
      @cupon[:validated] = false
      @cupon[:moip_id] = params[:moip_id]
      @cupon.save

      offer = @cupon.offer
      offer[:cupon_counter] = offer[:cupon_counter] - 1;
      offer.save

      user_card = user.user_cards[0]
      user_card[:card_number] = params[:part_card]
      user_card[:save_card] = params[:save_card] == "do"
      card_flag = CardFlag.find_by_code(params[:card_flag_code])
      user_card[:card_flag_id] = card_flag.nil? ? 1 : card_flag.id
      user_card.save
    else
      @cupon.destroy
    end
    success_message = "Sua transação foi processada pelo Moip Pagamentos S/A.
    A sua transação está #{@cupon.moip_status} e o código Moip é #{ @cupon.moip_id }.
    Caso tenha alguma dúvida referente a transação, entre em contato com o Moip."

    respond_to do |format|
      format.html {
        flash[:notice] = success_message
        redirect_to :controller => "cupons", :action => "index", :user_id => current_user.id
      }
    end
  end

  def confirm_printed
    @current_user = current_user
    @offer = Offer.find(params[:id])
    @transaction_id = Random.rand 00001..99999

    dt = DateTime.now.to_i
    unique_key = "Traz#{Random.new(dt.hash + @current_user.hash).rand(10000)}"

    @cupon = Cupon.create :user_id => @current_user.id,
                 :offer_id => @offer.id,
                 :price => @offer.price,
                 :credit_discount => 10,
                 :good_date => Time.now,
                 :cupon_code => "",
                 :monthly_cupon_accounting_id => 0,
                 :transaction_id => @transaction_id,
                 :nasp_key => "asdsd45",
                 :approved => true,
                 :moip_status => "Aprovado"

    success_message = "Sua transação está #{@cupon.moip_status} e o código  é #{ @cupon.transaction_id }.
    Caso tenha alguma dúvida referente a transação, entre em contato."

    respond_to do |format|
      format.html {
        flash[:notice] = success_message
        redirect_to :controller => "cupons", :action => "index", :user_id => current_user.id
      }
    end

  end

  def validate_cupons
    @partner = Partner.find params[:partner_id]
    @today_cupons = Cupon.find_today_by_partner @partner.id

    respond_to do |format|
      format.html
    end
  end

  def validate
    unless params[:cupon_code].nil?
      code_list = params[:cupon_code].split(",")
      bill_value = params[:bill_value].split("|") unless params[:bill_value].nil?
      d('bill value',bill_value)

      validated = ""
      not_validated = ""

      code_list.each_with_index do |cupon_code, index|
        cupon = Cupon.find_by_cupon_code cupon_code.strip[1..-1]

        if cupon.nil?
          not_validated = not_validated + ", " + cupon_code
        else
          if params[:validate]
              b_value = (!bill_value.nil? and bill_value != []) ? bill_value[index].gsub(",", ".").to_f : cupon.offer.price
              d(b_value)
              cupon[:validated] = true
              cupon[:bill_value] = b_value
              cupon[:validated_date] = Time.now
              if cupon.save
                validated = validated + ", " + cupon_code
              end
          elsif params[:cancel] && cupon[:validated]
              cupon[:validated] = false
              cupon[:validated_date] = Time.now
              if cupon.save
                validated = validated + ", " + cupon_code
              end
          end
        end

      end
    end

    return_message = ""
    if params[:cancel] && validated != ""
      return_message = "Validações canceladas:  " + validated[2..-1]
    elsif params[:validate] && validated != ""
      return_message = "Vouchers validados: " + validated[2..-1]
    end

    if not_validated != ""
      return_message = return_message + (return_message != "" ? "<br />" : "") + "Vouchers não encontrados: " + not_validated[2..-1]
    end

    respond_to do |format|
      format.html { redirect_to({:controller => "partners", :action => "dashboard", :id => current_user.id}, :notice => return_message.html_safe)}
    end
  end

  def validate_user_cupon
    @cupon = Cupon.find_by_cupon_code params[:cupon_code]

    dist = nil
    if session[:user_latlong]
      user_latlong = session[:user_latlong]
      lat = user_latlong.split('|')[0]
      long = user_latlong.split('|')[1]

      partner = @cupon.offer.partner
      dist = partner.geo_distance lat.to_f, long.to_f
      @dist = dist
    end


    if !@cupon.nil? && !@cupon[:validated] && (dist.nil? || dist <= 0.050)
      @cupon[:validated] = true
      @cupon[:validated_date] = Time.now
      @cupon.save
    end


    respond_to do |format|
      format.js {render :status => 250}
    end
  end

  def share_cupon
    cupon = Cupon.find params[:id]

    if !current_user.nil? && !cupon.nil?
      current_user.share TimelineType.offer, {:offer_id => cupon.offer_id}
      #current_user.share_social cupon.offer.facebook_resume(cupon.user.name) , PrivacyType.offer

      current_user.share_social_voucher cupon.offer.facebook_resume(cupon.user.name) , PrivacyType.offer, cupon.offer
    end

    respond_to do |format|
      format.html { redirect_to :controller => "users", :action => "timeline", :id => current_user.id}
    end
  end

  def printed
    @cupon = Cupon.find params[:id]
    @print = true
    @no_header = true

    @rules = Rule.find_by_sql(["SELECT r.*
                                FROM rules r, offer_rules of
                                WHERE r.id = of.rule_id
                                AND of.offer_id = :oid
                                AND value > 0
                                AND offer_type = :otp", {:oid => @cupon.offer.id, :otp => @cupon.offer.ttype[0]}])
  end

  private

  def authenticate
    deny_access unless signed_in? USER_TYPE
  end

  def authenticate_partner
    deny_access unless signed_in? PARTNER_TYPE
  end

  def correct_user
    @user = User.find(params[:user_id])
    redirect_to(root_path, :notice => "Access Denied" ) unless current_user?(@user)
  end

  def correct_partner
    @partner = Partner.find(params[:partner_id])
    puts @partner
    redirect_to(root_path, :notice => "Access Denied" ) unless current_user?(@partner)
  end

end