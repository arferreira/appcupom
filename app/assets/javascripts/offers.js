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
	
		$("#offer_value_field").val( Math.round(offer_value*100)/100 );
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

