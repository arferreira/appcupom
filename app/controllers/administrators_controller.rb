# encoding: utf-8
class AdministratorsController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :destroy, :index, :pending_partners, :list_partners, :offers_date]
  before_filter :correct_user, :only => [:edit, :update, :destroy]
  
  # GET /administrators
  # GET /administrators.json
  def index
    @administrators = Administrator.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @administrators }
    end
  end

  # GET /administrators/1
  # GET /administrators/1.json
  def show
    @administrator = Administrator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @administrator }
    end
  end

  # GET /administrators/new
  # GET /administrators/new.json
  def new
    @administrator = Administrator.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @administrator }
    end
  end

  # GET /administrators/1/edit
  def edit
    @administrator = Administrator.find(params[:id])
  end

  # POST /administrators
  # POST /administrators.json
  def create
    @administrator = Administrator.new(params[:administrator])
    
    respond_to do |format|
      if @administrator.save
        format.html { redirect_to @administrator, notice: 'Administrator was successfully created.' }
        format.json { render json: @administrator, status: :created, location: @administrator }
      else
        format.html { render action: "new" }
        format.json { render json: @administrator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /administrators/1
  # PUT /administrators/1.json
  def update
    @administrator = Administrator.find(params[:id])

    respond_to do |format|
      if @administrator.update_attributes(params[:administrator])
        format.html { redirect_to @administrator, notice: 'Administrator was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @administrator.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /administrators/1/dashboard
  # GET /administrators/1/dashboard.json
  def dashboard
    @administrator = Administrator.find(params[:id])
    @cupons = Cupon.limit(1)
    @cuponsCalc = Cupon.all
    
    @numCupons = @cuponsCalc.count
    @money = 0
    
    @cuponsCalc.each do |cupon|
      @money += cupon.price
    end
    
    @money = @money / PROFIT;
    
    respond_to do |format|
      format.html # dashboard.html.erb
    end
  end
  
  def pending_partners
    @partners = Partner.find_by_sql('Select * from partners where approved = 0')
    
    respond_to do |format|
      format.html
    end
  end
  
  def approve_partner
    @partner = Partner.find(params[:id])
    
    respond_to do |format|
      format.html { redirect_to listar_parceiros_path, notice: "Parceiro #{@partner.company_name} aprovado" }
    end
  end
  
  def list_partners
    @partners = Partner.all
    
    respond_to do |format|
      format.html
    end
  end

  def offers_date
    date = nil
    d(params[:date])
    if params[:date]
      selected_day = params[:date]["day"].to_i
      selected_month = params[:date]["month"].to_i
      selected_year = params[:date]["year"].to_i
      d(selected_month)
      date = Date.new(selected_year, selected_month, selected_day)
      d(date)
    end 
    
    @offer_date = date || Time.now
    @offers = Offer.offers_by_date(@offer_date)

    respond_to do |format|
      format.html
    end
  end

  # DELETE /administrators/1
  # DELETE /administrators/1.json
  
private

  def authenticate
    deny_access unless signed_in? ADMIN_TYPE
  end
  
  def correct_user
    @admin = Administrator.find(params[:id])
    redirect_to(root_path, :notice => "Access Denied" )unless current_user?(@admin)
  end
  
end
