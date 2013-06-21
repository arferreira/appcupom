class MailPrivaciesController < ApplicationController
  #before_filter :authenticate, :only => [:edit, :show, :update, :destroy, :new, :create]
  
  # GET /mail_privacies
  # GET /mail_privacies.json
  def index
    @mail_privacies = MailPrivacy.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mail_privacies }
    end
  end

  # GET /mail_privacies/1
  # GET /mail_privacies/1.json
  def show
    @mail_privacy = MailPrivacy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mail_privacy }
    end
  end

  # GET /mail_privacies/new
  # GET /mail_privacies/new.json
  def new
    @mail_privacy = MailPrivacy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mail_privacy }
    end
  end

  # GET /mail_privacies/1/edit
  def edit
    @mail_privacy = MailPrivacy.find(params[:id])
  end

  # POST /mail_privacies
  # POST /mail_privacies.json
  def create
    @mail_privacy = MailPrivacy.new(params[:mail_privacy])

    respond_to do |format|
      if @mail_privacy.save
        format.html { redirect_to @mail_privacy, notice: 'Mail privacy was successfully created.' }
        format.json { render json: @mail_privacy, status: :created, location: @mail_privacy }
      else
        format.html { render action: "new" }
        format.json { render json: @mail_privacy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mail_privacies/1
  # PUT /mail_privacies/1.json
  def update
    @mail_privacy = MailPrivacy.find(params[:id])

    respond_to do |format|
      if @mail_privacy.update_attributes(params[:mail_privacy])
        format.html { redirect_to @mail_privacy, notice: 'Mail privacy was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mail_privacy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mail_privacies/1
  # DELETE /mail_privacies/1.json
  def destroy
    @mail_privacy = MailPrivacy.find(params[:id])
    @mail_privacy.destroy

    respond_to do |format|
      format.html { redirect_to mail_privacies_url }
      format.json { head :no_content }
    end
  end
  
private
  def authenticate
    deny_access unless signed_in? ADMIN_TYPE
  end
  
end
