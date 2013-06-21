# encoding: utf-8
class PartnerPicsController < ApplicationController
  before_filter :authenticate, :except => [:show]
  before_filter :correct_user, :except => [:show]
 
  # GET /partner_pics
  # GET /partner_pics.json
  def index
    @partner = Partner.find(params[:partner_id])
    @partner_pics = @partner.partner_pics
    
    #params to select mode
    # @num_select = params[:num_select]
    # @select_callback = params[:select_callback]
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /partner_pics/1
  # GET /partner_pics/1.json
  def show
    @partner_pic = PartnerPic.find(params[:id])
    @partner = @partner_pic.partner.id
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /partner_pics/new
  # GET /partner_pics/new.json
  def new
    @partner_pic = PartnerPic.new
    @partner = Partner.find(params[:partner_id])
    
    respond_to do |format|
      @partner_script_and_css = true
      @no_top_tool = true
      @partner_menu = true
      format.html # new.html.erb
    end
  end

  # GET /partner_pics/1/edit
  def edit
    @partner_pic = PartnerPic.find(params[:id])
    @partner = Partner.find(params[:partner_id])
    
    @partner_script_and_css = true
    @no_top_tool = true
    @partner_menu = true
  end

  # POST /partner_pics
  # POST /partner_pics.json
  def create
    @partner_pic = PartnerPic.new(params[:partner_pic])
    @partner = Partner.find(params[:partner_id])
    d(params[:pic_type])
    @partner_pic[:partner_id] = @partner.id
    @partner_pic.pic_type = params[:pic_type]
    
    respond_to do |format|
      if @partner_pic.save
        format.html { redirect_to edit_partner_path(@partner.id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /partner_pics/1
  # PUT /partner_pics/1.json
  def update
    @partner_pic = PartnerPic.find(params[:id])
    @partner = @offer.partner

    respond_to do |format|
      if @partner_pic.update_attributes(params[:partner_pic])
        format.html { redirect_to @partner }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /partner_pics/1
  # DELETE /partner_pics/1.json
  def destroy
    @partner_pic = PartnerPic.find(params[:id])
    

    respond_to do |format|
      if Offer.find_by_partner_pic1_id(@partner_pic.id).nil?
        @partner_pic.destroy
        format.html { redirect_to edit_partner_path(params[:partner_id]) }
      else
        format.html { redirect_to edit_partner_path(params[:partner_id]), :notice => "Imagem já está relacionada a uma oferta." }
      end
    end
  end
  
  
  # GET /partner/1/select_partner_pics
 # GET /partner/1/select_partner_pics
  def select_partner_pics
    selected_pics = params[:selected_pics]
    
    unless session[:keep_offer].nil?
      session[:keep_offer][:selected_pics] = nil
    end
    
    respond_to do |format|
      format.html { redirect_to url_for(params[:select_callback]+"?selected_pics=#{selected_pics}")  }
    end
  end
  
  
private

  def authenticate
    deny_access unless signed_in? PARTNER_TYPE
  end
  
  def correct_user
    @partner = Partner.find(params[:partner_id])
    redirect_to(root_path, :notice => "Access Denied" )unless current_user?(@partner)
  end
  
end
