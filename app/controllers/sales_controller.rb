class SalesController < ApplicationController
  def index
  	@cupons = Cupon.all


  end
end
