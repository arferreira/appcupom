# encoding: utf-8
class PartnerPasswordResetsController < ApplicationController
  before_filter :check_if_signed_in
  def new
    @title = "Criar conta"
    @menu = true
    @submenu = false
  end
  
  def create
    partner = Partner.find_by_email(params[:email])
    partner.send_password_reset if partner
    
    redirect_to '/p/signin', :notice => "Email enviado para recuperação de senha."
  end
  
  def edit
    @partner = Partner.find_by_password_reset_token!(params[:id])
    @no_header = true
    @dark = true
  end
  
  def update
    @partner = Partner.find_by_password_reset_token!(params[:id])
    d('partner password reset', @partner, '@partner.password_reset_sent_at', @partner.password_reset_sent_at, (@partner.password_reset_sent_at < 2.hours.ago))
        
    if @partner.password_reset_sent_at < 2.hours.ago
      redirect_to new_partner_password_reset_path, :alert => "Senha expirada."
    elsif @partner.update_attributes(params[:partner])
      sign_in @partner
      redirect_to @partner, :notice => "Senha recuperada!"
    else
      render :edit
    end
  end
  
  private

  def check_if_signed_in
    redirect_to root_path if signed_in?
  end
end
