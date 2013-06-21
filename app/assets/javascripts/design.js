window.log = function f(){ log.history = log.history || []; log.history.push(arguments); if(this.console) { var args = arguments, newarr; args.callee = args.callee.caller; newarr = [].slice.call(args); if (typeof console.log === 'object') log.apply.call(console.log, console, newarr); else console.log.apply(console, newarr);}};

(function(a){function b(){}for(var c="assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,markTimeline,profile,profileEnd,time,timeEnd,trace,warn".split(","),d;!!(d=c.pop());){a[d]=a[d]||b;}})
(function(){try{console.log();return window.console;}catch(a){return (window.console={});}}());



function createGallery($param) {( function(window, PhotoSwipe) {
			document.addEventListener('DOMContentLoaded', function() {
				var options = {}, instance = PhotoSwipe.attach(window.document.querySelectorAll($param + ' a'), options);
			}, false);
		}(window, window.Code.PhotoSwipe));
}

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

function blockMove(event) {
	event.preventDefault();
	return false;
}

// Inicia o modal
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
});

/*

// Listen for ALL links at the top level of the document. For
$( document ).on(
	"click",
	"a",
	function( event ){
 
		// Stop the default behavior of the browser, which
		// is to change the URL of the page.
		event.preventDefault();
 
		// Manually change the location of the page to stay in
		// "Standalone" mode and change the URL at the same time.
		location.href = $( event.target ).attr( "href" );
 
	}
);*/


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
	// @_toggleItem 	param o indice a ser clicado
	// @_toggleContent	param o conteudo, filho de _toggleItem, a ser ocultado
	
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

// Inicia o modal
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

});