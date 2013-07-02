# encoding: utf-8
module ApplicationHelper

  def has_location?
    unless session[:location_time].nil?
      timeout = Time.now - session[:location_time] > MAX_GPS_CACHE_TIME
    end
    !(session[:location_time].nil? || timeout || !session[:gps])
  end

  def get_location_before_link link_params
    "javascript:get_location_and_redirect(\"#{url_for(link_params)}\")"
  end
  
  #back button
  def back_button
    link_to content_tag(:span,"Voltar"), "javascript:history.back();", :class => "button back"
  end

  def search_button
    link_to_function "Pesquisar", "javascript:showSearch()", :class => "button search"
  end
  
  def credit_button
    link_to "Crédito", "/users/#{current_user.id}/credits", :class => "button credit"
  end

  def google_adwords
    javascript_tag 'var google_conversion_id = 938255232; var google_conversion_language = "en"; var google_conversion_format = "2"; var google_conversion_color = "ffffff"; var google_conversion_label = "lq0gCPDpnQUQgMeyvwM"; var google_conversion_value = 0;'
  end
  
  def get_controller user_type
    case user_type
    when USER_TYPE
      return "users"
    when PARTNER_TYPE
      return "partners"
    when ADMIN_TYPE
      return "administrators"
    end
  end
  
  def link_to_submit text, args
    link_to_function text, "$(this).closest('form').submit()", args
  end
  
  def link_to_submit_id finder, text, args, ajax = true
    if ajax
      link_to_function text, "ajax_submit($('#{finder}'))", args
    else
      link_to_function text, "$('#{finder}').submit()", args
    end
  end
  
  def link_to_submit_payment_id finder, text, args, ajax = true
    if ajax
      link_to_function text, "ajax_submit($('#{finder}'))", args
    else
      link_to_function text, "$('#{finder}').submit()", args
    end
  end
  
  def link_to_submit_comment_id finder, text, args
    link_to_function text, "if(preventSubmitTwice){$('#{finder}').submit(); preventSubmitTwice = false;}", args
  end
  
  def link_to_submit_pics_id finder, text, args
    link_to_function text, "var selected = $('#selected_pics_input').val();
                            if( selected == null || selected == ''){
                              alert('Selecione uma imagem.');
                            }
                            else{
                              $('#{finder}').submit();
                            }", args
  end
  
  #routing helper
  
  #partner
  def comment_p_recommandation(*args)
    new_partner_recommend_partner_rec_partner_comment(*args)
  end
  def n_rec_part_path(*args)
    new_partner_recommend_partner_path(*args)
  end
  def part_rec_path(*args)
    partner_recommend_partner_path(*args)
  end
  
  #product
  def n_rec_prod_path(*args)
    new_partner_product_recommend_product_path(*args)
  end
  def prod_rec_path(*args)
    partner_product_recommend_product_path(*args)
  end
  def n_wish_prod_path(*args)
    new_partner_product_wish_product_path(*args)
  end
  def prod_wished_path(*args)
    partner_product_wish_product_path(*args)
  end
  def n_rec_offer_path(*args)
    new_partner_offer_recommend_offer_path(*args)
  end
  def offer_rec_path(*args)
    partner_offer_recommend_offer_path(*args)
  end
  
  
  def get_category_icon partner
    category = partner.category
    if category.nil? || category == "" || category.icon.nil? || category.icon == ""
      return "self-service"
    else
      return category.icon
    end
  end
  
  def get_cities
    City.order(:id)
  end
  
  def get_selected_city
    if session[:city]
      session[:city]
    else
      City.first.id unless City.first.nil? 
    end
  end
  
  def breadcrumbs
    content_tag :span, :id=>"breadcrumbs" do
      if not session[:breadcrumbs].blank?
        session[:breadcrumbs].split(",").uniq.map{ |breadcrumb|
          link_to(" - "+breadcrumb.to_s.gsub("/"," ")+"",breadcrumb)
        }
      end
    end
  end
  def get_breadcrumbs(title, path)
    link_to title.to_s, path, :class => "migalha"
    #{}"/partners/#{@partner.id}/offers/#{@offer.id.nil? ? -1 : @offer.id}"
    #	link_to "Nivel 1", root_path, :class => "migalha"
    #class="migalha migalha-active"
  end
  
  def is_facebook_connected?
    !session[:facebook_user].nil?
  end
  
  def get_selected_category
    if session[:category]
      return session[:category]
    else
      category = Category.first 
      return category.id unless category.nil? 
    end
  end
  
  def get_selected_partner_category
    if session[:category]
      return session[:category]
    else
      category = Category.first 
      return category.id unless category.nil? 
    end
  end
  
  
  #debugger
  def vd (*args)
    unless true #Rails.env.production?
      p '                          '
      p '   DEBUGGER START (VIEW)  '
      p '   -   '
      p '   -   '
      args.each do |arg|
        p arg
        p '============================================='
      end
      p '   -   '
      p '   -   '
      p '   DEBUGGER END (VIEW)    '
      p '                          '
    end
  end
    
end


# new_partner_recommend_partner_rec_partner_comment GET    /partners/:partner_id/recommend_partners/:recommend_partner_id/rec_partner_comments/new(.:format)      rec_partner_comments#new

