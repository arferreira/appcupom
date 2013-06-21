# encoding: utf-8
class OfferCommentsController < ApplicationController
  # GET /offer_comments
  # GET /offer_comments.json
  def index
    @offer_comments = OfferComment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @offer_comments }
    end
  end

  # GET /offer_comments/1
  # GET /offer_comments/1.json
  def show
    @offer_comment = OfferComment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @offer_comment }
    end
  end

  # GET /offer_comments/new
  # GET /offer_comments/new.json
  def new
    @offer_comment = OfferComment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @offer_comment }
    end
  end

  # GET /offer_comments/1/edit
  def edit
    @offer_comment = OfferComment.find(params[:id])
  end

  # POST /offer_comments
  # POST /offer_comments.json
  def create
    @offer_comment = OfferComment.new(params[:offer_comment])

    respond_to do |format|
      if @offer_comment.save
        format.html { redirect_to @offer_comment, notice: 'Comentário criado com sucesso.' }
        format.json { render json: @offer_comment, status: :created, location: @offer_comment }
      else
        format.html { render action: "new" }
        format.json { render json: @offer_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /offer_comments/1
  # PUT /offer_comments/1.json
  def update
    @offer_comment = OfferComment.find(params[:id])

    respond_to do |format|
      if @offer_comment.update_attributes(params[:offer_comment])
        format.html { redirect_to @offer_comment, notice: 'Offer comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @offer_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offer_comments/1
  # DELETE /offer_comments/1.json
  def destroy
    @offer_comment = OfferComment.find(params[:id])
    @offer_comment.destroy

    respond_to do |format|
      format.html { redirect_to offer_comments_url }
      format.json { head :no_content }
    end
  end
end
