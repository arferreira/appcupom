# encoding: utf-8
class RecommendPartnersController < ApplicationController
  before_filter :authenticate, :only => :new
  
  # GET /recommend_partners
  # GET /recommend_partners.json
  def index
    @partner = Partner.find(params[:partner_id])
    @recommend_partners = RecommendPartner.order("created_at")

    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true
      format.html # index.html.erb
      format.json { render json: @recommend_partners }
      format.js {render :status => 250}
    end
  end

  # GET /recommend_partners/1
  # GET /recommend_partners/1.json
  def show
    @object = RecommendPartner.find(params[:id])
    @comments = @object.rec_partner_comments.order('created_at ASC')
    
    rec_partner_comment = RecPartnerComment.new
    @form_object = rec_partner_comment
    
    respond_to do |format|
      #@menu = true
      @title = "Comentários"
      @no_mobile_header = true
      format.html {render 'comments/comments'}
    end
  end

  # GET /recommend_partners/new
  # GET /recommend_partners/new.json
  def new
    @partner = Partner.find(params[:partner_id])
    @recommend_partner = RecommendPartner.new
    @user = current_user
    
    respond_to do |format|
      @menu = true
      @submenu = false
      
      format.html # new.html.erb
      format.json { render json: @recommend_partner }
      format.js {render :status => 250}
    end
  end

  # GET /recommend_partners/1/edit
  def edit
    @recommend_partner = RecommendPartner.find(params[:id])
    
    @menu = true
    @submenu = false
  end

  # POST /recommend_partners
  # POST /recommend_partners.json
  def create
    @recommend_partner = RecommendPartner.new(params[:recommend_partner])
    @partner = Partner.find(params[:partner_id])
    @user = current_user
    
    @recommend_partner.partner = @partner
    @recommend_partner.user    = @user

    respond_to do |format|
      if @recommend_partner.save
        #timeline
        @user.share TimelineType.recommend_partner, {:recommend_partner_id => @recommend_partner.id}
        #@user.share_social @recommend_partner.facebook_resume , PrivacyType.recommend_partner
        
        @user.share_social_partner @recommend_partner.facebook_resume, "#{root_url}partners/#{@partner.id}", PrivacyType.recommend_partner, @partner
        #badge
        @user.check_partner_recommendations session
        
        #mail
        #UserMailer.send_offer(@cupon).deliver

        format.html { redirect_to @partner, notice: 'Recomendação criada com sucesso.' }
        format.json { render json: @partner, status: :created, location: @recommend_partner }
        format.js {render :status => 250}
      else
        format.html { render action: "new" }
        format.json { render json: @recommend_partner.errors, status: :unprocessable_entity }
        format.js {render :status => 250}
      end
    end
  end

  # PUT /recommend_partners/1
  # PUT /recommend_partners/1.json
  def update
    @recommend_partner = RecommendPartner.find(params[:id])

    respond_to do |format|
      if @recommend_partner.update_attributes(params[:recommend_partner])
        format.html { redirect_to @recommend_partner, notice: 'Recomendação atualizada com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @recommend_partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recommend_partners/1
  # DELETE /recommend_partners/1.json
  def destroy
    d('destroy', params)
    @recommend_partner = RecommendPartner.find(params[:id])
    @partner = @recommend_partner.partner
    @recommend_partner.destroy

    respond_to do |format|
      format.html { redirect_to @partner }
      format.json { head :no_content }
    end
  end
  
  def unrecommend
    @recommend_partner = RecommendPartner.find(params[:recommend_partners_id])
    #recommend_partners_id
    @partner = @recommend_partner.partner
    @recommend_partner.destroy

    respond_to do |format|
      format.html { redirect_to @partner }
      format.json { head :no_content }
    end
  end
  
private

  def authenticate
    deny_access unless signed_in? USER_TYPE
  end
end
