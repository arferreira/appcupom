// Friends

function initFriendRequest() {

  $('.friend-list .refuse').bind('click', function() {
    //frRefuse($(this))
    $(this).addClass('active').parent().delay(800).slideToggle('slow', function() {
      $(this).remove();
    });
  });

  $('.friend-list .accept').bind('click', function() {
    $(this).addClass('active').parent().delay(800).slideToggle('slow', function() {
      $(this).remove();
    });
    frAdd($(this))
  });
}

function frRefuse(e) {
  e.addClass('active').parent().delay(800).slideToggle('slow', function() {
    e.remove();
  });

}

function frAdd(e) {
  var friend_target = '<li>' + e.parent().html() + '</li>';

  $('#friends-added').prepend(friend_target);
  $('#friends-added li:eq(0)').hide();
  $('#friends-added li:eq(0) .refuse').bind('click', function() {
    $(this).addClass('active').parent().delay(800).slideToggle('slow', function() {
      $(this).remove();
    });
  });
  $('#friends-added li:eq(0)').delay(800).slideToggle('slow');
}

function frRemove(e) {
  e.remove();
}


function OpenLink(theLink){
  window.location.href = theLink.href;
  return false;
}

function createGallery($param)
{
  (function(window, PhotoSwipe){
    document.addEventListener('DOMContentLoaded', function(){
      var
      options = {},
      instance = PhotoSwipe.attach( window.document.querySelectorAll($param + ' a'), options );
    }, false);
  }(window, window.Code.PhotoSwipe));
}

function initToggleList() {
  $(".toggle-item .toggle-list").hide();
}
function initToggleList(_toggleItem, _toggleContent) {
  // @_toggleItem   param o indice a ser clicado
  // @_toggleContent  param o conteudo, filho de _toggleItem, a ser ocultado
  
  $(_toggleContent, _toggleItem).slideToggle();

  $(_toggleItem).click(function(e) {
    if ($(this).hasClass("opened")) {
      $(this).removeClass("opened")
    } else {
      $(this).addClass("opened");
    }

    $(_toggleContent, this).slideToggle('fast');
  })
}

var preventDoubleClick = false;
function setOnClickSelectHandler(parent_class, output_id, max_select_input_id, toogle_class_id) {

  $(parent_class).live("click",  function() {
    if( preventDoubleClick ){
      var selected_input = $(output_id).val();
      var selected = selected_input.length == 0 ? [] : selected_input.split(',');
      var num_select = $(max_select_input_id).val();
      var indexOfSelected = selected.indexOf(this.id.substr(3));
      var removed;
      if (indexOfSelected != -1) {
        selected.splice(indexOfSelected, 1);
      } else {
        removed = selected.splice(0, selected.length - (num_select - 1), this.id.substr(3));
      }
      $(output_id).val(selected.join());

      $("#" + this.id).toggleClass(toogle_class_id);

      if (removed != null && removed.length != 0) {
        $("#id_" + removed[0]).toggleClass(toogle_class_id);
      }

      preventDoubleClick = false;
    }

  });
}

var m_watchId = 0;
var m_positionCounter = 0;
var m_lastLocation = null;
var m_interval = null;
var preventSubmitTwice = true;

function timeout(time){
  return new Date().getTime() - m_startDate > time;
}

function get_location_callback(location) {
  if(location == null && m_lastLocation == null){
    root_city_change(null);
  }
  else{
    if(m_lastLocation == null || (location != null && location.coords.accuracy < m_lastLocation))
      m_lastLocation = location;

    if(location == null || location.coords.accuracy < 10 || m_positionCounter > 3)
    {
      navigator.geolocation.clearWatch(m_watchId);

      getCity(m_lastLocation.coords.latitude, m_lastLocation.coords.longitude);
    }
    else
    {
      m_positionCounter++;
    }
  }
}

function callRoot(lat, lng, locality){
  var token = $('meta[name="csrf-token"]').attr('content');

  if ($("#get_location_callback").val() != null) {
    ajax_submit($('<form action="'+ $("#get_location_callback").val() +'" method="POST">' +
      '<input type="hidden" name="gps" value="1">' +
      '<input type="hidden" name="lat" value="' + lat + '">' +
      '<input type="hidden" name="long" value="' + lng + '">' +
      '<input type="hidden" name="city" value="' + (locality == null ? "0" : locality )+ '">' +
      '<input name="authenticity_token" type="hidden" value="' + token + '"/>' +
      '</form>').appendTo("#appendable"));

    return false;
  }
}

function root_city_change(city_id){
  var token = $('meta[name="csrf-token"]').attr('content');

  $('<form action="'+$("#get_location_callback").val()+'" id="root-city" method="POST">' +
    '<input type="hidden" name="city_id" value="' + (city_id == null ? "1" : city_id )+ '">' +
    '<input name="authenticity_token" type="hidden" value="' + token + '"/>' +
    '</form>').appendTo("#appendable");
  ajax_submit($("#root-city"))

  return false;
}

function get_cached_location_callback(location) {
  if(location == null){
    get_location_error();
  }
  else{
    var token = $('meta[name="csrf-token"]').attr('content');
    if ($("#get_location_callback").val() != null) {
      $.ajax({
        type: 'POST',
        url: $("#get_location_callback").val(),
        data: {
          'gps': "1",
          'lat': location.coords.latitude,
          'long': location.coords.longitude,
          'authenticity_token': token
        }
      });
    }
  }
}

function post_empty_location(){
  var token = $('meta[name="csrf-token"]').attr('content');
  if ($("#get_location_callback").val() != null) {
    $.ajax({
      type: 'POST',
      url: $("#get_location_callback").val(),
      data: {
        'gps': "0",
        'authenticity_token': token
      },
    });
  }
}

function get_location_error(error){
  if(error == null){
    return;
  }
  else if(error.code == error.TIMEOUT){
    get_location_callback(null);
  }
  else{
    // alert("Seu dispositivo não forneceu a localicação.");var token = $('meta[name="csrf-token"]').attr('content');
    $('<form action="'+ $("#get_location_callback").val() +'" id="root-city" method="POST">' +
      '<input type="hidden" name="gps" value="0">' +
      '<input name="authenticity_token" type="hidden" value="' + token + '"/>' +
      '</form>').appendTo("#appendable");
  ajax_submit($("#root-city"))
  }
}

function clearWatch(){
  clearInterval(m_interval);
  navigator.geolocation.clearWatch(m_watchId);
  get_location_callback(null);
}

function city_selected(){
$('#city').change(function() {
   // Antonio solução temporaria
   
});
}
function getCity(lat, lng){
  var geocoder = new google.maps.Geocoder();
  var locality = null;
  var latLong = new google.maps.LatLng(lat, lng);

  geocoder.geocode({'latLng': latLong}, function(results, status){
    if (status == google.maps.GeocoderStatus.OK) {
      for (var component in results[0]['address_components']) {
        for (var i in results[0]['address_components'][component]['types']) {
          if (results[0]['address_components'][component]['types'][i] == "locality") {
            locality = results[0]['address_components'][component]['short_name'];
          }
        }
      }
    }

    callRoot(lat, lng, locality);
  });
}


function submit_payment_form(finder){

  $(finder).submit();

}

$(window).bind("statechange", function(){
  if(ajaxnavchange == true){
    ajaxnavchange = false;
  }else{
    var rootUrl = History.getRootUrl();
    var State = History.getState();
    var href = "/" + State.url.replace(rootUrl, "");
    return ajaxnav(href);
  }
})

function ajaxnav(href, params, meth){

  if(typeof params === "undefined"){
    params = {}
  }
  if(typeof meth === "undefined"){
    meth = "get"
  }
  //$("body").scrollTop(0);//animate({scrollTop: 0}, "slow");
//    window.scrollTo(0,0);
  $(".loading").show();
  $.ajax({
        url: href,
        type: meth,
        data: params,
        success: function(data, textStatus, jqXhr){
      if(jqXhr.status == 250)
        eval(data);
      else{
            $(".round").html(data);

        ajaxnavchange = true;
        History.pushState(null, "TrazCupom", href);
      }
      $(".loading").hide();
        },
        error: function(data, textStatus, jqXhr){
      window.location = href;
        }
      })
    return false;
}



function ajax_submit(form){
  //$(form).submit();
  var action = $(form).attr("action")
  var values = {};
  $.each($(form).serializeArray(), function(i, field) {
      values[field.name] = field.value;
  });
  return ajaxnav(action, values, "POST");
}

function showSearch(){
  if($(".search-mobile .search-input").is(":visible")){
    $('.search-mobile .search-input').hide();
    $(this).removeClass("active-btn");
  }else{
    $('.search-mobile .search-input').show();
    $(this).addClass("active-btn");
  }
}



function get_location_and_redirect(href){
  $("body").append("<input type='hidden' name='request_location' id='request_location' value='true' /><input type='hidden' name='get_location_callback' id='get_location_callback' value='"+href+"' />")
  $("#loading").show();
  // navigator.geolocation.getCurrentPosition(get_location_callback, get_location_error, {maximumAge:10000, enableHighAccuracy:true});
  m_startDate = new Date().getTime();
  m_watchId = navigator.geolocation.watchPosition(get_location_callback,
    get_location_error,
    {maximumAge:0, timeout:3000, enableHighAccuracy:true});

  m_interval = setTimeout(function(){clearWatch()},7000);
}

$(document).on("focus", '#telefone', function() {
  $(this).mask('(99) 9999-9999');
}).blur(function() {
  $(this).unmask();
});
$(document).on("keyup", '#estado', function(){
  this.value = this.value.toUpperCase();
});
$(document).on("focus", '#cep', function() {
  $(this).mask('99999-999');
}).blur(function() {
  $(this).unmask();
});

$(document).on("focus", '#DataNascimento', function() {
  $(this).mask('99/99/9999');
}).blur(function() {
  $(this).unmask();
});

$(document).on("focus", '#Identidade', function() {
  $(this).mask('999.999.999-99');
}).blur(function() {
  $(this).unmask();
});
$(document).on("focus", '#Expiracao', function(){
  $(this).mask('99/99');
}).blur(function(){
  $(this).unmask();
});


// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var map = null;
function loadGMaps_partnerShow() {
    var canvas = $("#map_canvas");
    var img = $(canvas).find("img");
    var src = $(img).attr("src");
    $(canvas).attr("style", "background: url("+src+") center center;");
    $(img).replaceWith("");
  /*var latLong = $("#partner_latlong").val().split("|");
  var map_img = "http://maps.googleapis.com/maps/api/staticmap?center="+latLong[0]+","+latLong[1]+"&zoom=13&size=500x102&sensor=false&markers="+latLong[0]+","+latLong[1];
  alert(map_img);
  var partnerName = $("#partner_name").val();
  var gLatLong = new google.maps.LatLng(latLong[0], latLong[1])
  var myOptions = {
    center : gLatLong,
    zoom : 15,
    mapTypeId : google.maps.MapTypeId.ROADMAP,
    mapTypeControl: false,
    navigationControl: false,
    streetViewControl: true,
    scrollwheel: false

  };
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

  var mapPin = new google.maps.MarkerImage('/assets/pin.png',
    new google.maps.Size(28,41),
    new google.maps.Point(0,0),
    new google.maps.Point(14,41)
    );

  var marker = new google.maps.Marker({
    position : gLatLong,
    title : partnerName,
    icon : mapPin,
    zIndex:4,
    animation : google.maps.Animation.DROP
  });
  marker.setMap(map);

  var userLatLong = $("#user_latlong").val().split("|");
  var gUserLatLong = new google.maps.LatLng(userLatLong[0], userLatLong[1])
  if (userLatLong != null) {
    var user_marker = new google.maps.Marker({
      position : gUserLatLong,
      title : "Eu",
      animation : google.maps.Animation.DROP
    });
    user_marker.setMap(map);
  }*/
}


function select_partner_category(category_id){
  var token = $('meta[name="csrf-token"]').attr('content');
  var params = {}
  if($("#search_string").val()){
    params = {
      category: category_id,
      search: $("#search_string").val(),
      authenticity_token: token
    }
  }
  else{
    params = {
      category: category_id,
      authenticity_token: token
    }
  }

  return ajaxnav("/partners_category", params, "POST");
}
function abre_modal(){
  //seleciona os elementos a com atributo name="modal"
  $('a[name=modal]').live("click",  function(e) {
    //cancela o comportamento padrão do link
    e.preventDefault();

    //armazena o atributo href do link
    var id = $(this).attr('href');

    //armazena a largura e a altura da tela
    var maskHeight = (document.height !== undefined) ? document.height : document.body.offsetHeight;
    var maskWidth = $(window).width();

    //Define largura e altura do div#mask iguais ás dimensões da tela
    $('#mask').css({
      'width' : maskWidth,
      'height' : maskHeight
    });

    //efeito de transição
    $('#mask').fadeIn(500);
    $('#mask').fadeTo(.4, 0.8);

    //armazena a largura e a altura da janela
    var winH = $(window).height();
    var winW = $(window).width();
    //centraliza na tela a janela popup
    $(id).css('top', winH / 2 - $(id).height() / 2);
    $(id).css('left', winW / 2 - $(id).width() / 2);
    //efeito de transição
    $(id).fadeIn(500);
  });

  //se o botãoo fechar for clicado
  $('.window .close').live("click",  function(e) {
    //cancela o comportamento padrão do link
    e.preventDefault();
    $('#mask, .window').hide();
  });

  //se div#mask for clicado
  $('#mask').live("click",  function() {
    $(this).hide();
    $('.window').hide();
  });
}
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function set_offer_price(){
  var price_array = $(".prods_price");
  var count_array = $(".offer_prod_count");
  var price = 0;

  for( var i = 0 ; i < price_array.length ; i++ ){
    price += parseFloat(price_array[i].firstChild.nodeValue.substr(3).replace(",", ".")) * count_array[i].value;
  }

  return price;
}

function set_discount(){
  var total_value = $("#price_field").val();
  if(total_value != ""){
    total_value = parseFloat(total_value.replace(",", "."));
    var now_discount = Math.ceil(total_value/10);
    var partner_discount = $("#discount").val()/100.0;

    var partner_value = total_value * (1-partner_discount);
    var offer_value = partner_value + now_discount;

    $("#offer_value_field").val( Math.round(partner_value*100)/100 );
    $("#partner_value_field").html( "R$ " + Math.round(partner_value*100)/100 );
    $("#nowon_value_field").html( "R$ " + now_discount );
    atualizaPreview();
  }
}

function select_offer_category(category_id){
  var token = $('meta[name="csrf-token"]').attr('content');
  params = {
    category: category_id,
    authenticity_token: token
  }
  return ajaxnav("/category", params, "POST");
}

function set_selected_prods(){
  var counter = 0;
  var ids = "";
  var qty = "";
  var price = "";
  var qty_list = $('.offer_prod_count');
  $('.product_row').each(function(){
    ids += "," + $(this).attr("data-id");
    price +="," + $(this).attr("data-preco-unitario");
    qty += "," + qty_list[counter++].value;
  });

  $("#selected_products").val(ids.substr(1));
  $("#selected_products_qty").val(qty.substr(1));
  $("#selected_products_price").val(price.substr(1));
}

function toggle_value(text_field, bill_field, value, bill_value){
  var text = text_field.val();
  var bill = bill_field.val();

  if(text.trim() == "" || text == "Insira a lista de cupons..."){
    text = value;
    bill = bill_value;
  }
  else if(text.indexOf(value) == -1){
    text += ", " + value;
    bill += "| " + bill_value;
  }
  else{
    text = text.replace(", " + value, "");
    text = text.replace(value, "");

    bill = bill.replace("| " + bill_value, "");
    bill = bill.replace(bill_value, "");
  }

  text_field.val(text);
  bill_field.val(bill);
}

function change_offer_type(obj){
  if( obj.getAttribute("id") == "offer_ttype_po" && obj.checked){
    $("#products_group").slideDown("fast");
    $(".areaProdutos").show();
    $(".tabelaResumoOferta").show();
    $("#product_rules").show();
    $("#product_rules_resume").show();
      $("#credit_rules").hide();
      $("#credit_rules_resume").hide();
      $("#price_field").prop('readonly', true);
      atualizaListaProdutos();
  }
  else if( obj.getAttribute("id") == "offer_ttype_co" && obj.checked){
    $("#products_group").slideUp("fast");
    $(".tabelaResumoOferta").show();
      $("#credit_rules").show();
      $("#credit_rules_resume").show();
    $("#product_rules").hide();
    $("#product_rules_resume").hide();
    $("#price_field").prop('readonly', false);
  }
}

function set_rule(rule_component){
  var rule_id = rule_component.attr("id").substr(5);
  var val = rule_component.val()

  //Is qualitative
  if(rule_component.is("select")){
    if(val == 1){
        $("#rule_resume_"+rule_id).show();
    }
    else{
        $("#rule_resume_"+rule_id).hide();
    }
  }
  else{
    var text = $("#rule_resume_"+rule_id).html();
    var charInitPos = text.indexOf("#");
    var charEndPos = text.substr(charInitPos).indexOf(" ");

    var replaceText = text.substr(charInitPos, charEndPos);
      var text = text.replace(replaceText, "#" + val);
      $("#rule_resume_"+rule_id).html(text)
      $("#rule_resume_"+rule_id).show();
  }
}

function set_rules(){
  $(".select_rule").each(function(){
    set_rule($(this));
  });
}

$(document).ready(function(){
  setOnClickSelectHandler( ".partner_select_pic", "#selected_pics_input", "#num_select_input", "border_selected" );
  $(".tabelaResumoOferta").hide();

    if( $(".itemProdutoTabela").length > 0 ){
      $("#price_field").val( set_offer_price() );
    }

    if( $("#price_field").length > 0 && $("#price_field").val != null ) set_discount();

    if($(".offer_ttype").length != 0){
      change_offer_type($(".offer_ttype")[0]);
      change_offer_type($(".offer_ttype")[1]);
    }

  $(".offer_ttype").change(function(){
    change_offer_type(this);
  });

  $(".select_cupon").live("click",  function(){
    var cupon_id = $(this).attr("id");
    var cupon_code = $("#cupon_code_" + cupon_id);
    var bill_value = $("#bill_" + cupon_id);
    toggle_value($("#validateCupons"), $("#bill_value"), cupon_code.html(), bill_value.val());

    $(this).toggleClass("btnTrueOn");

    e.stopPropagation();
  });

    if( $("#price_field").length > 0 && $("#price_field").val != null ) set_discount();


    //Rules

    $(".rules_resume").hide();
    $(".select_rule").change(function(){
      set_rule($(this));
    });

    if($(".select_rule").length > 0){
      set_rules();
    }

});


// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var map = null;
function loadGMaps_partnerShow() {
    var canvas = $("#map_canvas");
    var img = $(canvas).find("img");
    var src = $(img).attr("src");
    $(canvas).attr("style", "background: url("+src+") center center;");
    $(img).replaceWith("");
  /*var latLong = $("#partner_latlong").val().split("|");
  var map_img = "http://maps.googleapis.com/maps/api/staticmap?center="+latLong[0]+","+latLong[1]+"&zoom=13&size=500x102&sensor=false&markers="+latLong[0]+","+latLong[1];
  alert(map_img);
  var partnerName = $("#partner_name").val();
  var gLatLong = new google.maps.LatLng(latLong[0], latLong[1])
  var myOptions = {
    center : gLatLong,
    zoom : 15,
    mapTypeId : google.maps.MapTypeId.ROADMAP,
    mapTypeControl: false,
    navigationControl: false,
    streetViewControl: true,
    scrollwheel: false

  };
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

  var mapPin = new google.maps.MarkerImage('/assets/pin.png',
    new google.maps.Size(28,41),
    new google.maps.Point(0,0),
    new google.maps.Point(14,41)
    );

  var marker = new google.maps.Marker({
    position : gLatLong,
    title : partnerName,
    icon : mapPin,
    zIndex:4,
    animation : google.maps.Animation.DROP
  });
  marker.setMap(map);

  var userLatLong = $("#user_latlong").val().split("|");
  var gUserLatLong = new google.maps.LatLng(userLatLong[0], userLatLong[1])
  if (userLatLong != null) {
    var user_marker = new google.maps.Marker({
      position : gUserLatLong,
      title : "Eu",
      animation : google.maps.Animation.DROP
    });
    user_marker.setMap(map);
  }*/
}


function select_partner_category(category_id){
  var token = $('meta[name="csrf-token"]').attr('content');
  var params = {}
  if($("#search_string").val()){
    params = {
      category: category_id,
      search: $("#search_string").val(),
      authenticity_token: token
    }
  }
  else{
    params = {
      category: category_id,
      authenticity_token: token
    }
  }

  return ajaxnav("/partners_category", params, "POST");
}
function abre_modal(){
  //seleciona os elementos a com atributo name="modal"
  $('a[name=modal]').live("click",  function(e) {
    //cancela o comportamento padrão do link
    e.preventDefault();

    //armazena o atributo href do link
    var id = $(this).attr('href');

    //armazena a largura e a altura da tela
    var maskHeight = (document.height !== undefined) ? document.height : document.body.offsetHeight;
    var maskWidth = $(window).width();

    //Define largura e altura do div#mask iguais ás dimensões da tela
    $('#mask').css({
      'width' : maskWidth,
      'height' : maskHeight
    });

    //efeito de transição
    $('#mask').fadeIn(500);
    $('#mask').fadeTo(.4, 0.8);

    //armazena a largura e a altura da janela
    var winH = $(window).height();
    var winW = $(window).width();
    //centraliza na tela a janela popup
    $(id).css('top', winH / 2 - $(id).height() / 2);
    $(id).css('left', winW / 2 - $(id).width() / 2);
    //efeito de transição
    $(id).fadeIn(500);
  });

  //se o botãoo fechar for clicado
  $('.window .close').live("click",  function(e) {
    //cancela o comportamento padrão do link
    e.preventDefault();
    $('#mask, .window').hide();
  });

  //se div#mask for clicado
  $('#mask').live("click",  function() {
    $(this).hide();
    $('.window').hide();
  });
}

$(document).ready(function() {
  //seleciona os elementos a com atributo name="modal"
  $('a[name=modal]').live("click",  function(e) {
    //cancela o comportamento padrão do link
    e.preventDefault();

    //armazena o atributo href do link
    var id = $(this).attr('href');

    //armazena a largura e a altura da tela
    var maskHeight = (document.height !== undefined) ? document.height : document.body.offsetHeight;
    var maskWidth = $(window).width();

    //Define largura e altura do div#mask iguais ás dimensões da tela
    $('#mask').css({
      'width' : maskWidth,
      'height' : maskHeight
    });

    //efeito de transição
    $('#mask').fadeIn(500);
    $('#mask').fadeTo(.4, 0.8);

    //armazena a largura e a altura da janela
    var winH = $(window).height();
    var winW = $(window).width();
    //centraliza na tela a janela popup
    $(id).css('top', winH / 2 - $(id).height() / 2);
    $(id).css('left', winW / 2 - $(id).width() / 2);
    //efeito de transição
    $(id).fadeIn(500);

    $(window).bind('resize', function() {
      //armazena a largura e a altura da janela
      var winH = $(window).height();
      var winW = $(window).width();
      //centraliza na tela a janela popup
      $(id).css('top', winH / 2 - $(id).height() / 2);
      $(id).css('left', winW / 2 - $(id).width() / 2);
      //armazena a largura e a altura da tela
      var maskHeight = (document.height !== undefined) ? document.height : document.body.offsetHeight;
      var maskWidth = $(window).width();
      //Define largura e altura do div#mask iguais ás dimensões da tela
      $('#mask').css({
        'width' : maskWidth,
        'height' : maskHeight
      });
    });

  });

  //se o botãoo fechar for clicado
  $('.window .close').live("click",  function(e) {
    //cancela o comportamento padrão do link
    e.preventDefault();
    $('#mask, .window').hide();
    $(window).unbind('resize');
  });

  //se div#mask for clicado
  $('#mask').live("click",  function() {
    $(this).hide();
    $('.window').hide();
    $(window).unbind('resize');
  });

  //abrir informacoes da badge que esta habilitada
  $(".badge-on").live("click",  function() {
    var idBadge = $(this).attr("rel");
    //pega o id da badge que esta no elemento rel
    $(".list-badge").hide();
    //esconde a listagem das badges
    $(".badge-info").hide();
    //esconde o titulo da modal

    $(".badge" + idBadge + "").fadeIn();
    //mostra a info sobre a badge clicada
    $(".bt-back-modal").show();
    //mostra a info sobre a badge clicada
  })

  $(".bt-back-modal").live("click",  function(e) {
    $(".info-badge").hide();
    //esconde a info sobre a badge clicada
    $(".bt-back-modal").hide();
    //esconde a info sobre a badge clicada
    $(".badge-info").show();
    //mostra o titulo da modal
    $(".list-badge").show();
    //mostra a listagem de badge
  });

  //verifica se existe a #index
  var homescreen = $("#homescreen").css("display");
  if (homescreen == "block") {
    var delay = 5000;
    if($("#login-container").length){
      delay = 1000;
    }
    
    $("#homescreen").delay(delay).animate({
      opacity : 0,
      //marginLeft : '-480px'
    }, 1500, function() {
      $(this).hide();
      $("#index").fadeIn();
    });
  }

  if (window.navigator.userAgent.indexOf('iPhone') != -1) {

    if (window.navigator.standalone == true) {
      //fullscreen
      $("#homescreen-alert").hide();
    } else {
      $("#homescreen-alert").show();
      $(".close-homescreen").bind("click", function() {
        $("#homescreen-alert").hide();

        $("#warning-home").slideDown();
      });

      $("#warning-home").bind("click", function() {
        $("#warning-home").hide();

        $("#homescreen-alert").fadeIn();
      });
    }

  }

if ($("#request_location").val() == "true") {
    // navigator.geolocation.getCurrentPosition(get_location_callback, get_location_error, {maximumAge:10000, enableHighAccuracy:true});
    m_startDate = new Date().getTime();
    m_watchId = navigator.geolocation.watchPosition(get_location_callback,
      get_location_error,
      {maximumAge:0, timeout:3000, enableHighAccuracy:true});

    m_interval = setTimeout(function(){clearWatch()},7000);
  }

  if( $("#request_maps").val() == "partner" ){
    loadGMaps_partnerShow();
  }

  if ($("#cached_location").val() == "true") {
    //navigator.geolocation.getCurrentPosition(get_cached_location_callback, get_location_error, {maximumAge:5000, enableHighAccuracy:true});
    post_empty_location();
  }

  if ($("#print_this_page").val() == "true") {
    window.print();
  }


  $(".recommended_products").live("click",  function(){
    var prod_id = $(this).attr("id").substr(11);
    $(".pv_class").hide();

    $(".pv_"+prod_id).show();
  });


/*
  $("a").live("click",  function(){
    e.stopImmediatePropagation();
    var href = $(this).attr("href");
      var matched = href.match(/^https?:\/\//i);
      if(matched == null){
        $.ajax({
          url: href,
          success: function(data){
            $(".main").html(data);
          },
          error: function(data){
            $(".main").html(data.responseText);
          }
        })
        return false;
      }else{
        return true;
      }
  })*/
/*
  $("#search-form, #search_form").live("submit", function(){
    var action = $(this).attr("action").replace("/#", "");
    var search = $(this).find("input[name=search]").val();
    return ajaxnav(action, {search: search});
  })*/
  //setOnClickSelectProductsHandler( );

  $("#product_product_family_id").change(function(){
    if($(this).val() == ""){
      $("#SelecionaProduto").show();
    }
    else{
      $("#SelecionaProduto").hide();
    }

  });

  if($("#product_product_family_id").val() != ""){
    $("#SelecionaProduto").hide();
  }

  $("#info-pessoais-toggle").live("click",  function(){
    $("#info-pessoais-form").slideToggle("fast");
    e.stopPropagation()
  });

  $("#info-password-toggle").live("click",  function(){
    $("#info-password-form").slideToggle("fast");
    e.stopPropagation()
  });

  $("#info-pic-toggle").live("click",  function(){
    $("#info-pic-form").slideToggle("fast");
    e.stopPropagation()
  });
  if ($('.timeline-items').length) {
    var paginating = false;
    if ($('.pagination').length) {
      $(window).bind("scroll", function() {
        var url;
        url = $('.pagination .next_page').attr('data-href');
        if(url === undefined) url = $('.pagination .next_page').attr('href');
        if (!paginating && url && $(window).scrollTop() > $(document).height() - $(window).height() - 380) {
          paginating = true
          $('.pagination').show().html("<div class='loader-products'></div>");
          $.ajaxSetup({ cache: true });
          return $.getScript(url, function(){
            $('.pagination').hide();
            paginating = false;
          });
        }
      });
      $(window).trigger("scroll");
    }
  };
});