# encoding: utf-8
module OffersHelper

  def get_profit
    @partner.system_profit
  end

  def options_quali_quant choise, field_name, value
    if choise == "QL"
      select_tag field_name, options_for_select([["Sim", "1"], ["Não", "0"]], value), :class => "select_rule"
    elsif choise == "QN"
      number_field_tag field_name, value, :min => 0, :max => 500, :class => "select_rule"
    end
  end

  def text_rule_value ttype, value
    if ttype == "QL"
      label_tag value == 1 ? "Sim" : "Não"
    elsif ttype == "QN"
      label_tag value
    end
  end

  def offer_rule_value offer, rule
    offer_rule = offer.offer_rules.find_by_rule_id(rule.id) unless offer.nil?
    vd(session[:keep_rule])
    if session[:keep_offer].nil? && !session[:keep_rule].nil?
      keep_offer_rule = session[:keep_rule]["edit_rule_#{rule.id}"]
    elsif !session[:keep_offer].nil?
      keep_offer_rule = session[:keep_offer]["rule_#{rule.id}"]
    end

    keep_offer_rule || (!offer.nil? && !offer_rule.nil? && offer_rule.value) || rule.default
  end

  def product_offer
    PRODUCT_OFFER
  end

  def credit_offer
    CREDIT_OFFER
  end

  #teste selected_products
  def get_offer_product_selected_prod offer_id, prod_id, index
    offer_product = Product.where('id = ?', prod_id)
    get_offer_product_name_from_session("selected_products", prod_id, index) || ( (offer_product.nil? || offer_product.size == 0)? 1 : offer_product.first.name )
  end

  #teste selected_products_price
  def get_offer_product_selected_prod_price offer_id, prod_id, index
    offer_product = Product.where('id = ?', prod_id)
    get_offer_product_qty_from_session("selected_products_price", prod_id, index) || ( (offer_product.nil? || offer_product.size == 0)? 1 : offer_product.first.price )
  end

  def get_offer_product_qty offer_id, prod_id, index
    offer_product = OfferProduct.where("offer_id = ? AND product_id = ?", offer_id, prod_id)
    get_offer_product_qty_from_session("selected_products_qty", prod_id, index) || ( (offer_product.nil? || offer_product.size == 0)? 1 : offer_product.first.product_qty )
  end

  def get_offer_product_qty_from_session session_name, prod_id, index
    out = nil
    unless session[:keep_offer].nil?
      unless session[:keep_offer][session_name].nil? || session[:keep_offer][session_name] == ""
        out = session[:keep_offer][session_name].split(",")[index]
      end
    end
    out
  end

  #teste pegar nome no banco baseado no id da sessão
  def get_offer_product_name_from_session session_name, prod_id, index
    out = nil
    unless session[:keep_offer].nil?
      unless session[:keep_offer][session_name].nil? || session[:keep_offer][session_name] == ""
        ids = session[:keep_offer][session_name].split(",")[index]
        names = Product.where('id = ?', ids)
        out = names.first.name
      end
    end
    out
  end

  def hide_product? offer
    offer.ttype == CREDIT_OFFER ||
      (offer.id.nil? &&
      !params[:selected_products] &&
        (!session[:keep_offer] ||
        !session[:keep_offer][:selected_products])
      )
  end

  def cupons_last offer
    if offer.cupon_counter == 0 || offer.cupon_counter == nil
      "Vouchers esgotados"
    else
      "Restam #{offer.cupon_counter} vouchers"
    end
  end

  def get_discount_options
     [
     ['40%', 40],
     ['50%', 50],
     ['60%', 60],
     ['70%', 70]
     ]
  end

  def submit_offer_id finder, text, args
    link_to_function text, "set_selected_prods(); if(!$('#selected_pics').val() == ''){ $('#{finder}').submit();}else{alert('Adicione uma imagem a oferta!')}", args
  end

end
