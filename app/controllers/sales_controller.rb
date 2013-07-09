class SalesController < ApplicationController
  before_filter :authenticate
  def index
  	@cupons = Cupon.all
  end
  
  private
  def authenticate
    deny_access unless signed_in? ADMIN_TYPE
  end
  
  def correct_user
    @admin = Administrator.find(params[:id])
    redirect_to(root_path, :notice => "Access Denied" )unless current_user?(@admin)
  end
end
