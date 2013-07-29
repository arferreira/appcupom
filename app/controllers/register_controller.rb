class RegisterController < ApplicationController
  before_filter :authenticate
  def index
  	@usuario = User.paginate(:page => params[:page], :per_page => 30)
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
