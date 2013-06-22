
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

$(document).ready(function() {
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

  $(".nowon-inner a").each(function(i){
    ajaxlinkbuilder($(this));
  })

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
});

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
//  window.location = href;
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
        $("#header-container a, .round a, #main-menu a").each(function(i){
          ajaxlinkbuilder($(this));
        })
        ajaxnavchange = true;
        History.pushState(null, "NowOn", href);
      }
      $(".loading").hide();
        },
        error: function(data, textStatus, jqXhr){
      window.location = href;
        }
      })
    return false;
}

function ajaxlinkbuilder(elmn){
  var href = $(elmn).attr("href");
  if(href.match(/^https?:\/\//i) == null && href.match(/facebook\//i) == null && href.match(/\.(jpg|jpeg|png|gif)/i) == null && href.match(/^javascript/i) == null && href.match(/^#/i) == null && href.match(/comofunciona|sign/i) == null && href.match(/print/i) == null){
    $(elmn).attr("data-href", href);
    $(elmn).attr("href", "javascript:void(0)");
  }
}

function ajax_submit(form){
  //$(form).submit();
  var action = $(form).attr("action").replace("/#", "");
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

$(document).on("click", ".nowon-inner a[data-href*='/']", function(){
  return ajaxnav($(this).attr("data-href"));
})

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
$('input[placeholder], textarea[placeholder]').placeholder();

$(document).ready(function() {

/**
* Validação
* @author Paulo
* plugin jquery validates
*/
$('#main_form').validate({
  rules:{
    logradouro:{
      required: true,
      minlength: 3
    },
    numero:{
      required: true,
      number: true
    },
    bairro:{
      required:true
    },
    cidade:{
      required:true
    },
    estado:{
      required:true,
      maxlength: 2,
      minlength:2
    },
    cep:{
      required:true
    },
    telefone:{
      required:true
    },
    name:{
      required:true
    },
    DataNascimento:{
      required:true
    },
    Identidade:{
      required:true
    }
  },
  messages:{
    logradouro:{
      required: "O campo endereço é obrigatorio.",
      minlength: "O campo endereço deve conter no mínimo 3 caracteres."
    },
    numero:{
      required:"O campo numero é obrigatorio.",
      number:"Esse campo deve ser preenchido somente com numeros"
    },
    bairro:{
      required:"O campo bairro é obrigatorio."
    },
    cidade:{
      required:"O campo cidade é obrigatorio."
    },
    estado:{
      required:"O campo estado é obrigatorio.",
      maxlength:"O padrão de estado são 2 letras maiúsculas, por exemplo: MG",
      minlength:"O padrão de estado são 2 letras maiúsculas, por exemplo: MG"
    },
    cep:{
      required:"O campo CEP é obrigatorio."
    },
    telefone:{
      required:"O campo telefone é obrigatorio."
    },
    name:{
      required:"O campo nome é obrigatorio."
    },
    DataNascimento:{
      required:"O campo data de nascimento é obrigatorio."
    },
    Identidade:{
      required:"O campo CPF é obrigatorio."
    }
  },
  errorElement: "span",
  errorClass: "alert alert-error"
});
});