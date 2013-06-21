// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var onSuccess = function(data){
	var offer_id = $("#cupon_id").val();
	var secure_code = $("#CodigoSeguranca").val();
	if(secure_code == null){
		secure_code = $("#security-code").val();
	}
	var transaction_id = $("#transaction_id").val();
	
	var card_flag_code = $('#card_flag_id').find(":selected").val();
	if(card_flag_code == null){
		card_flag_code = $("#card_flag_id").val();
	}
	
	var part_card = $("#Numero").val();
	part_card = part_card.substr(part_card.length - 4 , part_card.length);
	//window.location.replace("/offers/" + offer_id + "/confirmation/" + data.CodigoMoIP);
	
	var save_card = $('#save_card').val();
	if(save_card == null){
		save_card = "dont";
		if ($('#save_data').is(':checked')) {
			save_card = "do";
		}
	}else{
		save_card = "do";
	}
    
  	$('<form action="/cupons/' + offer_id + '/confirmation" method="POST">' + 
  		'<input type="hidden" name="part_card" value="' + part_card + '">' +
    	'<input type="hidden" name="moip_id" value="' + data.CodigoMoIP + '">' +
    	'<input type="hidden" name="status" value="' + data.Status + '">' +
    	'<input type="hidden" name="transaction_id" value="' + transaction_id + '">' +
    	'<input type="hidden" name="secure_code" value="' + secure_code + '">' +
    	'<input type="hidden" name="save_card" value="' + save_card + '">' +
    	'<input type="hidden" name="card_flag_code" value="' + card_flag_code + '">' +
    	'</form>').appendTo("#appendable").submit();
	    
};

var onFailed = function(data) {
	var returned;
	if(data.length == null){
		returned = data;
	}
	else{
		returned = data[0]
	}
	
	if(returned != null && returned.Mensagem != null){
	    alert('Falha no Moip: \n\n ' + returned.Mensagem);
	}
	else{
		alert('Favor verificar os dados do cartão, dados incorretos');
	}
	
    
};

processaPagtoCredito = function() {
    var settings = {
        "Forma": "CartaoCredito",
        "Instituicao": $('#card_flag_id').find(":selected").val(),
        "Parcelas": "1",
        "Recebimento": "AVista",
        "CartaoCredito": {
            "Numero": $("#Numero").val(),
            "Expiracao": $("#Expiracao").val(),
            "CodigoSeguranca": $("#CodigoSeguranca").val(),
            "Portador": {
                "Nome": $("#name2").val(),
                "DataNascimento": $("#DataNascimento2").val(),
                "Telefone": $("#telefone").val(),
                "Identidade": $("#Identidade2").val()
            }
        }
    }
    
    MoipWidget(settings);
    return settings;
}

processaPagtoCofre = function() {
    var settings = {
        "Forma": "CartaoCredito",
        "Instituicao": $('#card_flag_id').val(),
        "Parcelas": "1",
        "Recebimento": "AVista",
        "CartaoCredito": {
            "Cofre": $('#key').val(),
            "CodigoSeguranca": $('#security-code').val()
        }
    }
    MoipWidget(settings);
    
    return settings;
}

