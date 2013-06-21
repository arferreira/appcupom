# encoding: utf-8
class WishProductsController < ApplicationController
  # GET /wish_products
  # GET /wish_products.json
  def index
    @wish_products = WishProduct.all

    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true
      
      format.html # index.html.erb
      format.json { render json: @wish_products }
    end
  end

  # GET /wish_products/1
  # GET /wish_products/1.json
  def show
    @object = WishProduct.find(params[:id])
    @comments = @object.wish_product_comments.order('created_at ASC')
    
    wish_product_comment = WishProductComment.new
    @form_object = wish_product_comment
    
    respond_to do |format|
      @menu = true
      @submenu = false
      @no_mobile_header = true
      @title = "Comentários"
      format.html {render 'comments/comments'}
    end
  end

  # GET /wish_products/new
  # GET /wish_products/new.json
  def new
    @wish_product = WishProduct.new
    @partner = Partner.find(params[:partner_id])
    @product = Product.find(params[:product_id])
    @user = current_user

    respond_to do |format|
      @menu = true
      @submenu = false
      
      format.html # new.html.erb
      format.json { render json: @wish_product }
    end
  end

  # GET /wish_products/1/edit
  def edit
    @wish_product = WishProduct.find(params[:id])
    
    @menu = true
    @submenu = false
  end

  # POST /wish_products
  # POST /wish_products.json
  def create
    @wish_product = WishProduct.new(params[:wish_product])
    
    @partner = Partner.find(params[:partner_id])
    @product = Product.find(params[:product_id])
    @user = current_user
    
    @wish_product.product = @product
    @wish_product.user    = @user

    respond_to do |format|
      if @wish_product.save
        #timeline
        @user.share TimelineType.wish_product, {:wish_product_id => @wish_product.id}
        
        @user.share_social @wish_product.facebook_resume, "#{root_url}partners/#{params[:partner_id]}", {:name => "#{@product.name} (#{@partner.company_name})", :description => @product.description} , PrivacyType.wish_product
        
        #badge
        @user.check_product_wishes session
        
        format.html { redirect_to @partner, notice: 'Produto desejado com sucesso!' }
        format.json { render json: @product, status: :created, location: @wish_product }
      else
        format.html { render action: "new" }
        format.json { render json: @wish_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /wish_products/1
  # PUT /wish_products/1.json
  def update
    @wish_product = WishProduct.find(params[:id])

    respond_to do |format|
      if @wish_product.update_attributes(params[:wish_product])
        format.html { redirect_to @wish_product, notice: 'Wish product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @wish_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wish_products/1
  # DELETE /wish_products/1.json
  def destroy
    @wish_product = WishProduct.find(params[:id])
    @partner = Partner.find(params[:partner_id])
    #@product = @recommend_product.product
    @wish_product.destroy

    respond_to do |format|
      format.html { redirect_to @partner }
      format.json { head :no_content }
    end
  end

  def unwish
    @wish_product = WishProduct.find(params[:wish_products_id])
    @product = @wish_product.product
    @partner = @product.partner

    @wish_product.destroy

    respond_to do |format|
      format.html { redirect_to @partner }
      format.json { head :no_content }
    end
  end
end
