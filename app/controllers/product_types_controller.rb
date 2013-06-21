class ProductTypesController < ApplicationController
  before_filter :authenticate
  before_filter :correct_user, :except => [:show, :index]
  
  # GET /product_types
  # GET /product_types.json
  def index
    #p '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
    #p params[:partner_id]
    
    if params[:partner_id].nil?
      @product_types = ProductType.all
    else
      @partner = Partner.find(params[:partner_id])
      @product_types = @partner.product_types
      if @produtct_types == nil
        @product_types = ProductType.all
      end
    end

    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true
      
      format.html # index.html.erb
      format.json { render json: @product_types }
    end
  end

  # GET /product_types/1
  # GET /product_types/1.json
  def show
    @product_type = ProductType.find(params[:id])

    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true
      
      format.html # show.html.erb
      format.json { render json: @product_type }
    end
  end

  # GET /product_types/new
  # GET /product_types/new.json
  def new
    @product_type = ProductType.new
    
    session[:source] = params[:source] unless params[:source].nil?

    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true
      
      format.html # new.html.erb
      format.json { render json: @product_type }
    end
  end

  # GET /product_types/1/edit
  def edit
    @product_type = ProductType.find(params[:id])
        
    @partner_script_and_css = true
    @no_top_tool = true
    @partner_menu = true
  end

  # POST /product_types
  # POST /product_types.json
  def create

    @product_type = ProductType.new(params[:product_type])
    
    @partner_script_and_css = true
    @no_top_tool = true
    @partner_menu = true
        
    @source = session[:source]
	
    #begin sprint001
		if signed_in? PARTNER_TYPE
			if params[:partner_id].nil?
				@partner = current_user
			else
		  	@partner = Partner.find(params[:partner_id])
			end
			@product_type.partner = @partner
			@product_type.public = false
		elsif signed_in? ADMIN_TYPE
			@product_type.public = true
		end
		
		#d('parnter.', @partner.company_name, 'PT after', @product_type)
		#end sprint001

    respond_to do |format|
      if @product_type.save
        if @source == "fam"
          format.html { redirect_to new_partner_product_family_path }
        else
          format.html { redirect_to new_partner_product_path }
        end
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /product_types/1
  # PUT /product_types/1.json
  def update
    @product_type = ProductType.find(params[:id])
    @partner = Partner.find(params[:partner_id])
    
    @partner_script_and_css = true
    @no_top_tool = true
    @partner_menu = true
    
    d('PT CONTROLLER - UPDATE', @product_type.name, @partner.company_name)

    respond_to do |format|
      if @product_type.update_attributes(params[:product_type])
        format.html { redirect_to partner_products_path(@partner) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_types/1
  # DELETE /product_types/1.json
  def destroy
    @product_type = ProductType.find(params[:id])
    
    @partner = Partner.find(@product_type.partner_id)
        
    @alert = @product_type.ok_to_destroy
    
    d('ta no destroy, alerta = ', @alert)
    

    respond_to do |format|
      if @alert.to_s != 'OK'
        #d('nao ta ok pra apagar')
        format.html { redirect_to partner_product_path(@product_type.partner), notice: @alert.to_s }
      else
        @product_type.destroy
        #d('essa merda apagou!!!')
        format.html { redirect_to partner_products_path }
      end
    end
  end
  
  
  def deactivate
    @product_type = ProductType.find(params[:product_type_id])
    @partner = Partner.find(params[:partner_id])
    d('deactivate product_types', @product_type, @partner.company_name)
    #@product.destroy
    @product_type.active = false
    d('(deactivate) before save', @product_type)
    
    @product_type.save
    d('(deactivate) After save', @product_type)
    
    respond_to do |format|
      format.html { redirect_to partner_products_path }
      format.json { head :no_content }
    end
  end
  
  def activate
    @product_type = ProductType.find(params[:product_type_id])
    @partner = Partner.find(params[:partner_id])
    d('activate product_type', @product_type, @partner.company_name)
    #@product.destroy
    @product_type.active = true
    d('(activate) before save', @product_type)
    
    @product_type.save
    d('(activate) After save', @product_type)
    
    respond_to do |format|
      format.html { redirect_to partner_products_path }
      format.json { head :no_content }
    end
  end
  
  
  private

  def authenticate
    deny_access if signed_in? USER_TYPE
  end
  
  def correct_user
    if signed_in? PARTNER_TYPE
			if params[:partner_id].nil?
				@partner = current_user
			else
      	@partner = Partner.find(params[:partner_id])
			end
      redirect_to(root_path, :notice => "Access Denied" )unless current_user?(@partner)
    end
  end
  
end
