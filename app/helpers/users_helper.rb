module UsersHelper
  
  def edit? user
    current_user == user
  end
  
end
