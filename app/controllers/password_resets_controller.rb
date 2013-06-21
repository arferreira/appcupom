# encoding: utf-8
class PasswordResetsController < ApplicationController
  before_filter :check_if_signed_in
  def new
    @title = "Criar conta"
    @menu = true
    @submenu = false
  end
  
  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    
    redirect_to '/signin', :notice => "Email enviado para recuperação de senha."
  end
  
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
    @no_header = true
    @dark = true
  end
  
  def update
    @user = User.find_by_password_reset_token!(params[:id])
        
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Senha expirada."
    elsif @user.update_attributes(params[:user])
      sign_in @user
      redirect_to @user, :notice => "Senha recuperada com sucesso!"
    else
      render :edit
    end
  end
  
  private

  def check_if_signed_in
    redirect_to root_path if signed_in?
  end
end
