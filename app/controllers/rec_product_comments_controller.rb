# encoding: utf-8
class RecProductCommentsController < ApplicationController
  
  def index
    @rec_product_comments = RecProductComment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rec_product_comments }
    end
  end

  def create
    @comment = RecProductComment.new params[:rec_product_comment]
    rec_product = RecommendProduct.find params[:object_id]

    @comment[:recommend_product_id] = rec_product.id
    @comment[:user_id] = current_user.id
    
    #timeline
    if @comment.save
      current_user.share TimelineType.rec_product_comment, {:rec_product_comment_id => @comment.id} unless @comment.nil?
      current_user.share_social @comment.facebook_resume , PrivacyType.rec_product_comment
    end
    
    flash[:notice] = "Comentário enviado!"
    respond_to do |format|
      format.html {redirect_to [rec_product.product.partner, rec_product.product, rec_product]}
      format.js {render '/comments/create', :status => 250}
    end
  end
  
  # DELETE /partner_comments/1
  # DELETE /partner_comments/1.json
  def destroy
    @comment = RecProductComment.find(params[:id])
    
    @comments_num = ProductComment.find(:all, :conditions => ["recommend_product_id = ?", @comment.recommend_product.id]).count - 1
   
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to recommend_product_path }
      format.js {render :status => 250}
    end
  end
  
  # GET /rec_product_comments
  # GET /rec_product_comments.json
  #def index
   # @rec_product_comments = RecProductComment.all

    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @rec_product_comments }
   # end
  #end

  # GET /rec_product_comments/1
  # GET /rec_product_comments/1.json
  def show
    @rec_product_comment = RecProductComment.find(params[:id])

    respond_to do |format|
      @no_mobile_header = true
      
      format.html # show.html.erb
      format.json { render json: @rec_product_comment }
    end
  end

  # GET /rec_product_comments/new
  # GET /rec_product_comments/new.json
  def new
    @rec_product_comment = RecProductComment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rec_product_comment }
    end
  end

  # GET /rec_product_comments/1/edit
  def edit
    @rec_product_comment = RecProductComment.find(params[:id])
  end

  # POST /rec_product_comments
  # POST /rec_product_comments.json
  #def create
   # @rec_product_comment = RecProductComment.new(params[:rec_product_comment])

   # respond_to do |format|
   #   if @rec_product_comment.save
    #    format.html { redirect_to @rec_product_comment, notice: 'Rec product comment was successfully created.' }
    #    format.json { render json: @rec_product_comment, status: :created, location: @rec_product_comment }
    #  else
    #    format.html { render action: "new" }
    #    format.json { render json: @rec_product_comment.errors, status: :unprocessable_entity }
    #  end
    #end
  #end

  # PUT /rec_product_comments/1
  # PUT /rec_product_comments/1.json
  def update
    @rec_product_comment = RecProductComment.find(params[:id])

    respond_to do |format|
      if @rec_product_comment.update_attributes(params[:rec_product_comment])
        format.html { redirect_to @rec_product_comment, notice: 'Rec product comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rec_product_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rec_product_comments/1
  # DELETE /rec_product_comments/1.json
  def destroy
    @rec_product_comment = RecProductComment.find(params[:id])
    @rec_product_comment.destroy

    respond_to do |format|
      format.html { redirect_to rec_product_comments_url }
      format.json { head :no_content }
    end
  end
end
