class HomeController < ApplicationController
  def index
  	@usuarios_satisfeitos = contabiliza_usuarios
  	@economy = economia
  	@cupons = Cupon.count
    @parceiros = ultimos_parceiros
    @ofertas = ultimas_ofertas
    
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
