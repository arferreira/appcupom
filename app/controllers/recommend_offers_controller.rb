# encoding: utf-8
class RecommendOffersController < ApplicationController
  
  # GET /recommend_offers
  # GET /recommend_offers.json
  def index
    @recommend_offers = RecommendOffer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @recommend_offers }
    end
  end

  # GET /recommend_offers/1
  # GET /recommend_offers/1.json
  def show
    @object = RecommendOffer.find(params[:id])
    @comments = @object.rec_offer_comments.order('created_at asc') #BUG 15
    
    rec_offer_comment = RecOfferComment.new
    @form_object = rec_offer_comment
    
    respond_to do |format|
      #@menu = true      
      @title = "Comentários"
      @no_mobile_header = true
      format.html {render 'comments/comments'}
    end
  end

  # GET /recommend_offers/new
  # GET /recommend_offers/new.json
  def new
    @recommend_offer = RecommendOffer.new
    @partner = Partner.find(params[:partner_id])
    @offer = Offer.find(params[:offer_id])
    @user = current_user

    respond_to do |format|
      @menu = true
      @submenu = true
      
      format.html # new.html.erb
      format.json { render json: @recommend_offer }
    end
  end

  # GET /recommend_offers/1/edit
  def edit
    @recommend_offer = RecommendOffer.find(params[:id])
  end

  # POST /recommend_offers
  # POST /recommend_offers.json
  def create
    @recommend_offer = RecommendOffer.new(params[:recommend_offer])
    
    @partner = Partner.find(params[:partner_id])
    @offer = Offer.find(params[:offer_id])
    @user = current_user
    
    @recommend_offer.offer = @offer
    @recommend_offer.user    = @user
    

    respond_to do |format|
      if @recommend_offer.save
        #timeline
        @user.share TimelineType.recommend_offer, {:recommend_offer_id => @recommend_offer.id}
        
        @user.share_social @recommend_offer.facebook_resume , PrivacyType.recommend_offer
        
        format.html { redirect_to [@partner, @offer], notice: 'Recomendação criada com sucesso.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /recommend_offers/1
  # PUT /recommend_offers/1.json
  def update
    @recommend_offer = RecommendOffer.find(params[:id])

    respond_to do |format|
      if @recommend_offer.update_attributes(params[:recommend_offer])
        format.html { redirect_to @recommend_offer, notice: 'Recomendação atualizada com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @recommend_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recommend_offers/1
  # DELETE /recommend_offers/1.json
  def destroy
    @recommend_offer = RecommendOffer.find(params[:id])
    @partner = Partner.find(params[:partner_id])
    @offer = @recommend_offer.offer
    @recommend_offer.destroy

    respond_to do |format|
      format.html { redirect_to redirect_to [@partner, @offer] }
      format.json { head :no_content }
    end
  end
end
