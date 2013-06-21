$(function(){
	$('.slides').slides({
		preload: false,
		generateNextPrev: true
	});

	$(".btn-comece-agora").live("click",  function(){
		$(".modal").show();
		$(".wrapper-modal").slideDown();
	});

	$(".close-modal").live("click",  function(){
		$(".wrapper-modal").slideUp('slow', function() {
			$(".modal").hide();
		});		
	});

});