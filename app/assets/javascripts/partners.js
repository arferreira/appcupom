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
//Função que faz o endless page
//@author Paulo Henrique
function endlessPage(){
	jQuery(function() {
		var paginating = false;
		$(window).unbind("scroll");
		if($('#toggle-menu').length){
			if ($('.pagination').length) {
				/**
				* Aqui faz o carregamento no mobile, usando o final da pagina para carragar mais itens do cardapio
				*
				*/
				$(window).bind("scroll", function() {
					var url;
					url = $('.pagination .next_page').attr('data-href');
					if(url === undefined) url = $('.pagination .next_page').attr('href');
					if($('.load-more .web').is(':hidden') ) {
						if (!paginating && url && $(window).scrollTop() > $(document).height() - $(window).height() - 75) {
							$('.pagination').show().html("<div class='loader-products'></div>");
							ret = $.getScript(url, function(){
							});
							return ret;
						}
					}
				});
				/**
				* Aqui adiciona o ver mais no desktop(webapp)
				* @author Paulo Henrique
				*/
				$('.load-more .web .std-button').live('click',function(){
					var url;
					url = $('.pagination .next_page').attr('data-href');
					if(url === undefined) url = $('.pagination .next_page').attr('href');
					$('.pagination').show().html("<div class='loader-products'></div>");
					ret = $.getScript(url, function(){
					});
					return ret;
				});
				$(window).trigger("scroll");
			}
		}
		if ($('.explore-list').length) {
			if ($('.pagination').length) {
	    		$(window).bind("scroll", function() {
	      		var url;
				url = $('.pagination .next_page').attr('data-href');
				if(url === undefined) url = $('.pagination .next_page').attr('href');
	      		if (!paginating && url && $(window).scrollTop() > $(document).height() - $(window).height() - 380) {
	      				paginating = true
						$('.pagination').show().html("<div class='loader-products'></div>");
						$.ajaxSetup({ cache: true });
						ret = $.getScript(url, function(){
							$('.pagination').hide();
							paginating = false
							$("#header-container a, .round a").each(function(i){
								ajaxlinkbuilder($(this));
							})
	        			});
						return ret;
	      			}
		    	});
		    	$(window).trigger("scroll");
	  		}
		};
	});
}
endlessPage();