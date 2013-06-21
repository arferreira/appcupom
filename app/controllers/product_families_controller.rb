class ProductFamiliesController < ApplicationController
  before_filter :get_product_types, :except => [:index, :show, :remove]
  
  # GET /product_families
  # GET /product_families.json
  def index
    @product_families = ProductFamily.all

    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true
      
      format.html # index.html.erb
      format.json { render json: @product_families }
    end
  end

  # GET /product_families/1
  # GET /product_families/1.json
  def show
    @product_family = ProductFamily.find(params[:id])

    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true
      
      format.html # show.html.erb
      format.json { render json: @product_family }
    end
  end

  # GET /product_families/new
  # GET /product_families/new.json
  def new
    @product_family = ProductFamily.new

    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true
      
      format.html # new.html.erb
      format.json { render json: @product_family }
    end
  end

  # GET /product_families/1/edit
  def edit
    @product_family = ProductFamily.find(params[:id])
    
    @partner_script_and_css = true
    @no_top_tool = true
    @partner_menu = true
  end

  # POST /product_families
  # POST /product_families.json
  def create
    @product_family = ProductFamily.new(params[:product_family])
        
    if signed_in? PARTNER_TYPE
      if params[:partner_id].nil?
        @partner = current_user
      else
        @partner = Partner.find(params[:partner_id])
      end
      @product_family.partner = @partner
    end
    #end sprint001
    @partner_script_and_css = true
    @no_top_tool = true
    @partner_menu = true

    respond_to do |format|
      if @product_family.save
        session[:create_family] = @product_family.id 
        
        format.html { redirect_to new_partner_product_path(@partner.id), notice: 'Product Family was successfully created.' }
        format.json { render json: @product_family, status: :created, location: @product_family }
      else
        format.html { render action: "new" }
        format.json { render json: @product_family.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /product_families/1
  # PUT /product_families/1.json
  def update
    @product_family = ProductFamily.find(params[:id])
    @partner = Partner.find(params[:partner_id])

    #d('CONTROLLER!!!',@partner,@product_family)
        
    @partner_script_and_css = true
    @no_top_tool = true
    @partner_menu = true
        
    respond_to do |format|
      if @product_family.update_attributes(params[:product_family])
        
        format.html { redirect_to partner_products_path(@partner) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product_family.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_families/1
  # DELETE /product_families/1.json
  def destroy
    @product_family = ProductFamily.find(params[:id])
    
    @alert = @product_family.ok_to_destroy
    
    respond_to do |format|
      if @alert.to_s != 'OK'
        #d('nao ta ok pra apagar')
        format.html { redirect_to partner_product_path(@product_family.partner), notice: @alert.to_s }
      else
        @product_family.destroy
        #d('essa merda apagou!!!')
        format.html { render action: "new" }
      end
    end
  end
    
  def deactivate
    @product_family = ProductFamily.find(params[:product_family_id])
    @partner = Partner.find(params[:partner_id])
    d('deactivate product_family', @product_family, @partner.company_name)
    #@product.destroy
    @product_family.active = false
    d('(deactivate) before save', @product_family)
    
    @product_family.save
    d('(deactivate) After save', @product_family)
    
    respond_to do |format|
      format.html { redirect_to partner_products_path }
      format.json { head :no_content }
    end
  end
  
  def activate
    @product_family = ProductFamily.find(params[:product_family_id])
    @partner = Partner.find(params[:partner_id])
    d('activate product_family', @product_family, @partner.company_name)
    #@product.destroy
    @product_family.active = true
    d('(activate) before save', @product_family)
    
    @product_family.save
    d('(activate) After save', @product_family)
    
    respond_to do |format|
      format.html { redirect_to partner_products_path }
      format.json { head :no_content }
    end
  end
  
  private
  
  def get_product_types
    if params[:partner_id]
      @partner = Partner.find(params[:partner_id])
      @product_types = ProductType.find_all_by_partner_id(@partner.id)
    end
  end
end
