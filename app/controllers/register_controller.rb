class RegisterController < ApplicationController
  def index
  	@usuario = User.all
  end
end
