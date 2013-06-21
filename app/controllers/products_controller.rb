# encoding: utf-8
class ProductsController < ApplicationController
  before_filter :get_product_types, :except => [:index, :show, :remove]
  #before_filter :get_partners, :except => [:index, :show, :remove]
  before_filter :authenticate, :only => [:edit, :update, :destroy, :index, :show]
  before_filter :correct_user, :only => [:edit, :update, :destroy, :index]
  before_filter :breadcrumbs

  # GET /products
  # GET /products.json
  def index
    #@products = Product.find(:all, :conditions => [ "partner_id = ?", params[:partner_id]])
    @partner = Partner.find(params[:partner_id])
    
    @categories = ProductType.find_all_by_partner_id(@partner.id)
      
    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true
      
      format.html # index.html.erb
      format.json { render json: @products }
    end
      @bc = ["Index",'products_path(' + @partner.id.to_s + ')']
      session[:bc] = @bc
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
    @partner = Partner.find(params[:partner_id])
    
    #@recommend_products = RecommendProduct.find_by_sql('SELECT * FROM recommend_products WHERE product_id = ' + @product.id.to_s)
    
    @recommend_products = RecommendProduct.find_by_sql(['SELECT * FROM recommend_products WHERE product_id = :pid
                                                           AND (user_id IN (
                                                        SELECT eu.id FROM friendships f, users eu, users amigo
                                                         WHERE f.me_id = eu.id AND f.friend_id = amigo.id 
                                                           AND f.friend_id = :uid AND f.me_id IN
                                                           (SELECT friend_id FROM friendships WHERE me_id = :uid))
                                                            OR user_id = :uid)', {:pid => params[:id], :uid => current_user.id}])
        

    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true
      
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new
    @partner = Partner.find(params[:partner_id])
    
    @product_types = ProductType.find_all_by_partner_id_and_active(@partner.id, true)
    @product_families = ProductFamily.find_all_by_partner_id_and_active(@partner.id, true)
    
    
    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true
      
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
    @partner = Partner.find(params[:partner_id])
    
    @partner_script_and_css = true
    @no_top_tool = true
    @partner_menu = true
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])
    
    unless @product.product_family_id.nil?
      product_family = ProductFamily.find @product.product_family_id 
      @product.product_type_id = product_family.product_type_id
    end 
    
    # if params[:product][:price].to_s.include? ','
       # @preco = params[:product][:price]
       # @convert = @preco.sub!(',', '.').to_f
       # @product.price = @convert
    # end
    
    @product.price = params[:product][:price].gsub(",", ".").to_f
    
    #before_filter roda depois..
    @partner = current_user
    @product.partner_id = @partner.id
    
    #debug puts '#### partner id = ' + @partner.id.to_s
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true
  
    session.delete :create_family
    
    respond_to do |format|
      if @product.save
        format.html { redirect_to partner_products_path }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])
    @partner = Partner.find(params[:partner_id])
        
    # if params[:product][:price].to_s.include? ','
       # @preco = params[:product][:price]
       # @convert = @preco.sub!(',', '.').to_f
    # end
    
    @product.price = params[:product][:price].gsub(",", ".").to_f
    @product.update_attributes(params[:product])
    
    # @product.price = @convert unless @convert.nil?
    
    product_family_id = params[:product][:product_family_id]
    
    d('product', @product, 'params', params)
    
    unless product_family_id.nil? or product_family_id == ""
      product_family = ProductFamily.find product_family_id 
      @product.product_type_id = product_family.product_type_id
    end

    respond_to do |format|
      if @product.save
        format.html { redirect_to partner_products_path }
        format.json { head :no_content }
      else
        format.html {
          @partner_script_and_css = true
          @no_top_tool = true
          @partner_menu = true
          render "edit"
        }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @partner = Partner.find(@product.partner_id)
    
   # @product.destroy
        
    respond_to do |format|
      format.html { redirect_to partner_products_path }
      format.json { head :no_content }
    end
  end
  
  def deactivate
    @product = Product.find(params[:product_id])
    @partner = Partner.find(params[:partner_id])
    d('deactivate product', @product, @partner.company_name)
    #@product.destroy
    @product.active = false
    d('(deactivate) before save', @product)
    
    @product.save
    d('(deactivate) After save', @product)
    
    respond_to do |format|
      format.html { redirect_to partner_products_path }
      format.json { head :no_content }
    end
  end
  
  def activate
    @product = Product.find(params[:product_id])
    @partner = Partner.find(params[:partner_id])
    d('activate product', @product, @partner.company_name)
    #@product.destroy
    @product.active = true
    d('(activate) before save', @product)
    
    @product.save
    d('(activate) After save', @product)
    
    respond_to do |format|
      format.html { redirect_to partner_products_path }
      format.json { head :no_content }
    end
  end

  
  def select
    @partner = Partner.find(params[:partner_id])
    @product = @partner.active_products
  end

  
  # GET /partner/1/select_products
  # GET /partner/1/select_products
  def select_products
    selected_products = params[:selected_prods]
    
    session[:keep_offer][:selected_products] = nil
    respond_to do |format|
      format.html { redirect_to url_for(params[:select_callback]+"?selected_products=#{selected_products}")  }
    end
  end

  
  def show_edits?
    @partner_edits = Partner.find(params[:partner_id])
    if @partner_show == current_user
      true
    else
      false
    end
  end
  
  private
  
  def get_product_types
    @partner = Partner.find(params[:partner_id])
    @product_types = ProductType.find_by_sql('SELECT * FROM product_types WHERE public = 1 OR partner_id = ' + @partner.id.to_s)
    @product_families = ProductFamily.find_all_by_partner_id(@partner.id)
    if @product_families == nil
      redirect_to new_partner_product_family_path
    end
  end
  
  def authenticate
    deny_access unless signed_in? PARTNER_TYPE
  end
  
  def correct_user
    @partner_show = Partner.find(params[:partner_id])
    redirect_to('/p/signin', :notice => "Access Denied" )unless @partner_show == current_user
  end
  
  def breadcrumbs
    @bc = Array.new unless @bc != nil
    #@bc = session[:bc] unless session[:bc] == nil
    #d('in breadcrumbs',@bc)
  end
  
end
