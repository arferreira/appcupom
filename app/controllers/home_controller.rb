class HomeController < ApplicationController
  def index
    if params[:get_location]
      @request_location = "true"
      @location_callback = "/offers"
    end
    if params[:gps] == "1"
      lat = params[:lat]
      long = params[:long]

      session[:location_time] = Time.now
      session[:gps] = 1

      city = City.find_by_name(params[:city])
      session[:city] = city.id unless city.nil?
      @gps = session[:gps]
    else
      if params[:city_id]
        @gps = nil
        session[:city] = params[:city_id]
        @city = City.find params[:city_id]
        @city ||= City.first

        lat = @city.latitude.to_s
        long = @city.longitude.to_s
      else
        @gps = session[:gps]
        if session[:user_latlong]
          user_latlong = session[:user_latlong]
          lat = user_latlong.split('|')[0]
          long = user_latlong.split('|')[1]
        else
          city = City.first
          lat = city.latitude.to_s
          long = city.longitude.to_s
        end
      end

    end

    @user_latlong = lat + "|" + long
    session[:user_latlong] = @user_latlong


  	@usuarios_satisfeitos = contabiliza_usuarios
  	@economy = economia
  	@cupons = Cupon.count
    @parceiros = ultimos_parceiros
    #@ofertas = ultimas_ofertas
    @ofertas = Offer.find_now_by_position lat, long, session[:city]
    
  end

  def contabiliza_usuarios
  	@qtd = User.count
  end

  def economia

  	#economia
    valores_originais = Offer.all.map(&:original_price).inject(:+)
    valores_com_desconto = Offer.all.map(&:price).inject(:+)
    @economizaram = valores_originais - valores_com_desconto
  	
  end

  def ultimos_parceiros
    #mostrar os parceiros com maior rank de cupons baixados
    @partners = Partner.last(3)
  end
  def ultimas_ofertas
    #pegar por região do user que está on-line e mostrar as ofertas
    # que estão com os cupons se esgotando
    @offers = Offer.last(3)
  end
end
