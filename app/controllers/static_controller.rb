class StaticController < ApplicationController

 # before_filter :authenticate, :only => [:comofunciona]
  respond_to :html, :json

  add_breadcrumb 'Sobre', '', :only => [:sobre]
  add_breadcrumb 'Termos', '', :only => [:termos]
  add_breadcrumb 'Privacidade', '', :only => [:privacidade]

  def sobre
    respond_with(
      @menu = true,
    ) 
  end

  def termos
    respond_with(
      @menu = true,
    )
  end

  def privacidade
    respond_with(
      @menu = true,
    )
  end
  def comofunciona
    if mobile_device?
      redirect_to "/signin"
    else
      render :layout => false
    end
  end
  def error
    render :layout => false

  end

  private
  def authenticate
    deny_access if (signed_in? USER_TYPE) || (signed_in? PARTNER_TYPE) || (signed_in? ADMIN_TYPE)
  end
  
end
