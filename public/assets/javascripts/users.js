// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){

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