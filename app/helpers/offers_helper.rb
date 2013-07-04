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
      "Cupons esgotados"
    else
      "Restam #{offer.cupon_counter} cupons"
    end
  end

  def get_discount_options
     [
       ['10%', 10],
       ['11%', 11],
       ['12%', 12],
       ['13%', 13],
       ['14%', 14],
       ['15%', 15],
       ['16%', 16],
       ['17%', 17],
       ['18%', 18],
       ['19%', 19],
       ['20%', 20],
       ['21%', 21],
       ['22%', 22],
       ['23%', 23],
       ['24%', 24],
       ['25%', 25],
       ['26%', 26],
       ['27%', 27],
       ['28%', 28],
       ['29%', 29],
       ['30%', 30],
       ['31%', 31],
       ['32%', 32],
       ['33%', 33],
       ['34%', 34],
       ['35%', 35],
       ['36%', 36],
       ['37%', 37],
       ['38%', 38],
       ['39%', 39],
       ['40%', 40],
       ['41%', 41],
       ['42%', 42],
       ['43%', 43],
       ['44%', 44],
       ['45%', 45],
       ['46%', 46],
       ['47%', 47],
       ['48%', 48],
       ['49%', 49],
       ['50%', 50],
       ['51%', 51],
       ['52%', 52],
       ['53%', 53],
       ['54%', 54],
       ['55%', 55],
       ['56%', 56],
       ['57%', 57],
       ['58%', 58],
       ['59%', 59],
       ['60%', 60],
       ['61%', 61],
       ['62%', 62],
       ['63%', 63],
       ['64%', 64],
       ['65%', 65],
       ['66%', 66],
       ['67%', 67],
       ['68%', 68],
       ['69%', 69],
       ['70%', 70],
       ['71%', 71],
       ['72%', 72],
       ['73%', 73],
       ['74%', 74],
       ['75%', 75],
       ['76%', 76],
       ['77%', 77],
       ['78%', 78],
       ['79%', 79],
       ['80%', 80],
       ['81%', 81],
       ['82%', 82],
       ['83%', 83],
       ['84%', 84],
       ['85%', 85],
       ['86%', 86],
       ['87%', 87],
       ['88%', 88],
       ['89%', 89],
       ['90%', 90],
       ['91%', 91],
       ['92%', 92],
       ['93%', 93],
       ['94%', 94],
       ['95%', 95],
       ['96%', 96],
       ['97%', 97],
       ['98%', 98],
       ['99%', 99]
     ]
  end

  def submit_offer_id finder, text, args
    link_to_function text, "set_selected_prods();$('#{finder}').submit()", args
  end

end
