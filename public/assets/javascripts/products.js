// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){
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
	 
});
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


