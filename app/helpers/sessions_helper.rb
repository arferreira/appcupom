module SessionsHelper
  
  #User
  def sign_in(accessor)
    cookies.permanent.signed[:remember_token] = [accessor.id, accessor.salt, accessor.access_type]
    self.current_user = accessor
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  #retorna usuario logado no sistema
  def current_user
    @current_user ||= accessor_from_remember_token
  end
  
  #retorna se o usuario passado como parametro
  #é o usuario que esta logado no sistema
  def current_user?(user)
    user == current_user
  end
  
  def accessor_from_remember_token
    case remember_token_type
      when USER_TYPE
        User.authenticate_with_salt(*remember_token)
      when PARTNER_TYPE
        Partner.authenticate_with_salt(*remember_token)
      when ADMIN_TYPE
        Administrator.authenticate_with_salt(*remember_token)
    end
  end
  
  def user_type
    return remember_token_type
    # case remember_token_type
      # when USER_TYPE
        # 'USER'
      # when PARTNER_TYPE
        # 'PARTNER'
      # when ADMIN_TYPE
        # 'ADMIN'
    # end
  end
  
  def remember_token
    cookies.signed[:remember_token][0..1] || [nil, nil]
  end
  
  def remember_token_type
    r_token = cookies.signed[:remember_token]
    r_token.pop unless r_token.nil?  
  end
  
  def signed_in? access_type = nil
    !current_user.nil? &&
    unless access_type.nil?
      current_user.access_type == access_type
    else
      true
    end
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
    reset_session
  end
  
  def deny_access
    redirect_to signin_path, :notice => ""
  end

  def deny_access_admin
    redirect_to "/a/signin", :notice => "Favor logar no sistema"
  end

  def facebook_logged?
    !session[:facebook_user].nil?
  end
  
end
