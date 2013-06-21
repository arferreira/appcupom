# encoding: utf-8
class WishProductCommentsController < ApplicationController
  # GET /wish_product_comments
  # GET /wish_product_comments.json
  def index
    @wish_product_comments = WishProductComment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @wish_product_comments }
    end
  end

  # GET /wish_product_comments/1
  # GET /wish_product_comments/1.json
  def show
    @wish_product_comment = WishProductComment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wish_product_comment }
    end
  end

  # GET /wish_product_comments/new
  # GET /wish_product_comments/new.json
  def new
    @wish_product_comment = WishProductComment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @wish_product_comment }
    end
  end

  # GET /wish_product_comments/1/edit
  def edit
    @wish_product_comment = WishProductComment.find(params[:id])
  end

  # POST /wish_product_comments
  # POST /wish_product_comments.json
  # def create
    # @wish_product_comment = WishProductComment.new(params[:wish_product_comment])
# 
    # respond_to do |format|
      # if @wish_product_comment.save
        # #timeline
        # user.share TimelineType.wish_product_comment, {:wish_product_comment_id => @wish_product_comment.id}
        # user.share_social @wish_product_comment.timeline_resume , PrivacyType.wish_product_comment
#         
        # format.html { redirect_to @wish_product_comment, notice: 'Wish product comment was successfully created.' }
        # format.json { render json: @wish_product_comment, status: :created, location: @wish_product_comment }
      # else
        # format.html { render action: "new" }
        # format.json { render json: @wish_product_comment.errors, status: :unprocessable_entity }
      # end
    # end
  # end
  
  def create
    @comment = WishProductComment.new params[:wish_product_comment]
    wish_product = WishProduct.find params[:object_id]

    @comment[:wish_product_id] = wish_product.id
    @comment[:user_id] = current_user.id
    
    #timeline
    if @comment.save
      current_user.share TimelineType.wish_product_comment, {:wish_product_comment_id => @comment.id}
      #current_user.share_social @comment.facebook_resume , PrivacyType.wish_product_comment
    end
    
    flash[:notice] = "Comentário enviado!"
    respond_to do |format|
      format.html {redirect_to [wish_product.product.partner, wish_product.product, wish_product]}
      format.js {render '/comments/create', :status => 250}
    end
  end

  # PUT /wish_product_comments/1
  # PUT /wish_product_comments/1.json
  def update
    @wish_product_comment = WishProductComment.find(params[:id])

    respond_to do |format|
      if @wish_product_comment.update_attributes(params[:wish_product_comment])
        format.html { redirect_to @wish_product_comment, notice: 'Wish product comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @wish_product_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wish_product_comments/1
  # DELETE /wish_product_comments/1.json
  def destroy
    @wish_product_comment = WishProductComment.find(params[:id])
    @wish_product_comment.destroy

    respond_to do |format|
      format.html { redirect_to wish_product_comments_url }
      format.json { head :no_content }
    end
  end
end
