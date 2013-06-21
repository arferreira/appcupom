# encoding: utf-8
class RecommendProductsController < ApplicationController
  # GET /recommend_products
  # GET /recommend_products.json
  def index
    @recommend_products = RecommendProduct.order("created_at")

    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true
      
      format.html # index.html.erb
      format.json { render json: @recommend_products }
    end
  end

  # GET /recommend_products/1
  # GET /recommend_products/1.json
  def show
    @object = RecommendProduct.find(params[:id])
    @comments = @object.rec_product_comments.order('created_at desc') #BUG 15
    
    rec_product_comment = RecProductComment.new
    @form_object = rec_product_comment
    
    respond_to do |format|
      #@menu = true      
      @title = "Comentários"
      @no_mobile_header = true
      format.html {render 'comments/comments'}
    end
  end

  # GET /recommend_products/new
  # GET /recommend_products/new.json
  def new
    @recommend_product = RecommendProduct.new
    @partner = Partner.find(params[:partner_id])
    @product = Product.find(params[:product_id])
    @user = current_user

    respond_to do |format|
      @menu = true
      @submenu = false
      
      format.html # new.html.erb
      format.json { render json: @recommend_product }
    end
  end

  # GET /recommend_products/1/edit
  def edit
    @recommend_product = RecommendProduct.find(params[:id])
    @menu = true
    @submenu = false
  end

  # POST /recommend_products
  # POST /recommend_products.json
  def create
    @recommend_product = RecommendProduct.new(params[:recommend_product])
    
    @partner = Partner.find(params[:partner_id])
    @product = Product.find(params[:product_id])
    @user = current_user
    
    @recommend_product.product = @product
    @recommend_product.user    = @user
    

    respond_to do |format|
      if @recommend_product.save
        #timeline
        @user.share TimelineType.recommend_product, {:recommend_product_id => @recommend_product.id}
        
        @user.share_social @recommend_product.facebook_resume, "#{root_url}partners/#{params[:partner_id]}" , {:name => "#{@product.name} (#{@partner.company_name})", :description => @product.description} ,PrivacyType.recommend_product
        
        #badge
        @user.check_product_recommendations session
        
        format.html { redirect_to @partner, notice: 'Recomendação criada com sucesso.' }
        format.json { render json: @product, status: :created, location: @recommend_product }
      else
        format.html { render action: "new" }
        format.json { render json: @recommend_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /recommend_products/1
  # PUT /recommend_products/1.json
  def update
    @recommend_product = RecommendProduct.find(params[:id])

    respond_to do |format|
      if @recommend_product.update_attributes(params[:recommend_product])
        format.html { redirect_to @recommend_product, notice: 'Recomendação atualizda com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @recommend_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recommend_products/1
  # DELETE /recommend_products/1.json
  def destroy
    @recommend_product = RecommendProduct.find(params[:id])
    @partner = Partner.find(params[:partner_id])
    @product = @recommend_product.product
    @recommend_product.destroy

    respond_to do |format|
      format.html { redirect_to [@partner, @product] }
      format.json { head :no_content }
    end
  end

  def unrecommend
    @recommend_product = RecommendProduct.find(params[:recommend_products_id])
    @product = @recommend_product.product
    @partner = @product.partner
    
    @recommend_product.destroy

    respond_to do |format|
      format.html { redirect_to @partner }
      format.json { head :no_content }
    end
  end
end
