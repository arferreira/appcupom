$(document).ready(function() {	

	$('.itemCardapio .nomeItemCardapio, .itemCardapio .setaDrop').live("click",  function() {
		var informacao = $(this).parent();
		var informacaoFilho = $(this).parent().parent().children('.subItemCardapio');
		var setaItem = $(this).parent().children('.setaDrop');
		if(informacaoFilho.is(':visible')){
			informacaoFilho.slideUp();
			informacao.removeClass('abertoSelect');
			setaItem.removeClass('aberto');
		}else{
			informacaoFilho.slideDown();
			informacao.addClass('abertoSelect');
			setaItem.addClass('aberto');
		}
		
	});

	$('.subItemCardapio .nomeItemCardapio, .subItemCardapio .setaDrop').live("click",  function() {
		var informacao = $(this).parent();
		var informacaoFilho = $(this).parent().parent().children('.infoItemCardapio');
		var setaItem = $(this).parent().children('.setaDrop');
		var inf_id = informacao.attr("id"); 
		var id;
		if(inf_id != null){
			id = inf_id.substr(2);
		}
		if(informacaoFilho.is(':visible')){
			if(id != null){
				$("#pv_" + id).slideUp();
			}
			informacao.removeClass('abertoSelect');
			setaItem.removeClass('aberto');
		}else{
			if(id != null){
				$("#pv_" + id).slideDown();
			}
			informacao.addClass('abertoSelect');
			setaItem.addClass('aberto');
		}
		
	});
	
	$('.submitDadosPerfil').live("click",  function() {
		$('.formCadastroPerfil').submit();
	});

	if($(".formCadastroPerfil").html()){
		$(".formCadastroPerfil").validate({
			rules: {
				nomeFantasia: "required",
				razaoSocial: "required",
				filePerfil: "required",
				nomeFantasia: "required",
				razaoSocial: "required",
				cnpj: "required",
				categoria: "required",
				anoDeInauguracao: "required",
				capacidade: "required",
				nomeContato: "required",
				telefone: "required",
				celular: "required",
				email: {
					required: true,
					email: true
				},
				site: "required",
				descricao: "required",
				horarios: "required",
				cep: "required",
				logradouro: "required",
				numero: {
					required: true,
					number: true
				},
				bairro: "required",
				complemento: "required",
				cidade: "required",
				estado: "required",
				latitude: "required",
				longitude: "required"
			},
			messages: {
				nomeFantasia: "Campo Obrigatório",
				razaoSocial: "Campo Obrigatório",
				filePerfil: "Campo Obrigatório",
				nomeFantasia: "Campo Obrigatório",
				razaoSocial: "Campo Obrigatório",
				cnpj: "Campo Obrigatório",
				categoria: "Campo Obrigatório",
				anoDeInauguracao: "Campo Obrigatório",
				capacidade: "Campo Obrigatório",
				nomeContato: "Campo Obrigatório",
				telefone: "Campo Obrigatório",
				celular: "Campo Obrigatório",
				email: {
					required: "Campo Obrigatório",
					email: "Digite um email válido"
				},
				site: "Campo Obrigatório",
				descricao: "Campo Obrigatório",
				horarios: "Campo Obrigatório",
				cep: "Campo Obrigatório",
				logradouro: "Campo Obrigatório",
				numero: {
					required: "Campo Obrigatório",
					number: "Campo precisa ser numérico"
				},
				bairro: "Campo Obrigatório",
				complemento: "Campo Obrigatório",
				cidade: "Campo Obrigatório",
				estado: "Campo Obrigatório",
				latitude: "Campo Obrigatório",
				longitude: "Campo Obrigatório"
			}
		});
	}

	

	/***************************Oferta Client Side**************************/
	atualizaPreview();
	atualizaInfoDestaque();

	$('.boxDiasSemanaOferta input[type="checkbox"],.boxHorarioOferta select,#price_field').change(function(){
		atualizaPreview();			
	});
	$('#destaqueoferta').keyup(function(event) {
		atualizaInfoDestaque();
	});	


	/*Incluindo produto na lista de exibição*/
	$('.btnAdicionarProduto').live("click",  function() {
		var nomeNovoProduto = $(this).parent().children('.infoListaProduto').children('.nomeProduto').text();
		var precoNovoProdutoFloat = $(this).parent().children('.infoListaProduto').children('.precoProduto').attr('data-preco');
		var precoNovoProdutoChar = $(this).parent().children('.infoListaProduto').children('.precoProduto').text();
		var product_id = $(this).parent().children('.infoListaProduto').children('.precoProduto').attr('data-id');
		var htmlNovoItemProduto = "<tr \
		class='itemProdutoTabela product_row' \
		data-nome-produto='"+nomeNovoProduto+"' \
		data-preco-unitario='"+precoNovoProdutoFloat+"' \
		data-preco-total='"+precoNovoProdutoFloat+"' \
		data-unidades='1'\
		data-id='"+product_id+"'>\
			<td><span class='nomeNovoProduto'>"+nomeNovoProduto+"</span></td>\
			<td><span class='precoNovoProduto'>"+precoNovoProdutoChar+"</span></td>\
			<td>\
			<select name='qtdProdutos' id='qtdProdutos' class='qtdProdutos offer_prod_count'>\
					<option value='1' selected>1</option>\
					<option value='2'>2</option>\
					<option value='3'>3</option>\
					<option value='4'>4</option>\
					<option value='5'>5</option>\
					<option value='6'>6</option>\
					<option value='7'>7</option>\
					<option value='8'>8</option>\
					<option value='9'>9</option>\
					<option value='10'>10</option>\
					<option value='11'>11</option>\
					<option value='12'>12</option>\
					<option value='13'>13</option>\
					<option value='14'>14</option>\
					<option value='15'>15</option>\
					<option value='16'>16</option>\
					<option value='17'>17</option>\
					<option value='18'>18</option>\
					<option value='19'>19</option>\
					<option value='20'>20</option>\
					<option value='21'>21</option>\
					<option value='22'>22</option>\
					<option value='23'>23</option>\
					<option value='24'>24</option>\
					<option value='25'>25</option>\
					<option value='26'>26</option>\
					<option value='27'>27</option>\
					<option value='28'>28</option>\
					<option value='29'>29</option>\
					<option value='30'>30</option>\
					<option value='31'>31</option>\
					<option value='32'>32</option>\
					<option value='33'>33</option>\
					<option value='34'>34</option>\
					<option value='35'>35</option>\
					<option value='36'>36</option>\
					<option value='37'>37</option>\
					<option value='38'>38</option>\
					<option value='39'>39</option>\
					<option value='40'>40</option>\
					<option value='41'>41</option>\
					<option value='42'>42</option>\
					<option value='43'>43</option>\
					<option value='44'>44</option>\
					<option value='45'>45</option>\
					<option value='46'>46</option>\
					<option value='47'>47</option>\
					<option value='48'>48</option>\
					<option value='49'>49</option>\
					<option value='50'>50</option>\
				</select>\
			</td>\
			<td>\
				<a class='btnFalseNova excluirProduto' href='javascript:void(0);''>X</a>\
			</td>\
		</tr>";	
		if(!$('.tabelaNovaOferta .nomeNovoProduto').html()){
			$('.tabelaNovaOferta').append(htmlNovoItemProduto);
			exibeMsgSucesso();
			marcarProduto(nomeNovoProduto);
			atualizaListaProdutos();
		}else{
			flag = 0;
			$(".nomeNovoProduto").each(function(){								
				if($(this).text()==nomeNovoProduto)		
					flag = 1;		
			});		
			if(flag==0){
				$('.tabelaNovaOferta').append(htmlNovoItemProduto);	
				exibeMsgSucesso();
				marcarProduto(nomeNovoProduto);
				atualizaListaProdutos();	
			}	
		}
		atualizaPreview();
		set_discount();
	});

	$('.qtdProdutos').live('change',function() {
		var item = $(this).parent().parent();
		var qtdProdutos = $(this).val();
		var precoUnidade = item.attr('data-preco-unitario');
		var valorTotal = qtdProdutos*precoUnidade;
		valorTotal = valorTotal.toFixed(2);
		item.attr('data-preco-total',valorTotal);
		item.attr('data-unidades',qtdProdutos);
		atualizaListaProdutos();
		atualizaPreview();
		set_discount();
	});

	$('.excluirProduto').live('click', function() {	
		nomeProdutoExcluir = $(this).parent().parent().attr('data-nome-produto');
		$(this).parent().parent().fadeOut('normal',function(){
			$(this).remove();
			desmarcarProduto(nomeProdutoExcluir);
			atualizaListaProdutos();
			atualizaPreview();
			set_discount();
		});				
	});	

	$('#discount').live('change',function() {
		atualizaPreview();		
		set_discount();
	});
	
	$("#price_field").live('change', function(e) {
  		atualizaPreview();
  		set_discount();
  	});

	$('.tipoOferta').change(function() {
		atualizaPreview();
		var valorSelecionado = $(this).val();
		if(valorSelecionado == 'po'){
			$('.areaProdutos').show();
			$('.areaCreditos').hide();
			$('.areaCreditosPorcentagem').hide();
			$('.ValorDaOferta8').show();
		}
		if(valorSelecionado == 'pco'){
			$('.areaCreditosPorcentagem').show();
			$('.areaProdutos').hide();
			$('.areaCreditos').hide();
			$('.ValorDaOferta8').hide();
			$('#price_field').val(1)
			$('#offer_value_field').val(1)
		}
		if(valorSelecionado == 'co'){
			$('.areaCreditos').show();
			$('.ValorDaOferta8').show();
			$('.areaCreditosPorcentagem').hide();
			$('.areaProdutos').hide();
		}
	});
	$('.valorOfertaCredito').keyup(function() {
		atualizaPreview();
	});

});

function atualizaDropDescontos(tipo){
	if(tipo =='produtos'){
		var valorTotalAtual = $('#price_field').text();
		var elementoAlvoTxt = $('.tabelaResumoOferta.opcaoProduto #discount');
	}else{
		var valorTotalAtual = $('.valorOfertaCredito').val();
		var elementoAlvoTxt = $('.tabelaResumoOferta.opcaoCredito #discount');		
	}		
	var des40 = 40/100*valorTotalAtual; des40=des40.toFixed(2);
	var des50 = 50/100*valorTotalAtual; des50=des50.toFixed(2);
	var des60 = 60/100*valorTotalAtual; des60=des60.toFixed(2);
	var des70 = 70/100*valorTotalAtual; des70=des70.toFixed(2);
	var htmlOptions = "\
		<option value='40' selected>40% - R$"+des40+"</option>\
		<option value='50'>50% - R$"+des50+"</option>\
		<option value='60'>60% - R$"+des60+"</option>\
		<option value='70'>70% - R$"+des70+"</option>\
		";
	elementoAlvoTxt.html(htmlOptions);	
}

function atualizaSuaParte(tipo){
	if(tipo =='produtos'){
		var valorTotalAtual = $('#price_field').text();
		var elementoAlvoTxt = $('.tabelaResumoOferta.opcaoProduto #suaParte');	
		var percentualDesconto = $('.tabelaResumoOferta.opcaoProduto #discount').val();	
	}else{
		var valorTotalAtual = $('.valorOfertaCredito').val();
		var elementoAlvoTxt = $('.tabelaResumoOferta.opcaoCredito #suaParte');
		var percentualDesconto = $('.tabelaResumoOferta.opcaoCredito #discount').val();			
	}	
	var resultadoSuaParte = valorTotalAtual-(percentualDesconto/100*valorTotalAtual);
	resultadoSuaParte = resultadoSuaParte.toFixed(2);	
	elementoAlvoTxt.html(resultadoSuaParte);
}

function atualizaListaProdutos(){
	var totalProdutos = 0;
	$(".tabelaNovaOferta .itemProdutoTabela").each(function(){								
		totalProdutos += $(this).attr('data-preco-unitario')*$(this).attr('data-unidades');	
	});	
	totalProdutos = totalProdutos.toFixed(2);	
	$('#price_field').val(totalProdutos);	
	$('#price_field').trigger("change");
}

function atualizaInfoDestaque(){
	if($('#destaqueoferta').val()=="")
		$('#txtdestaqueoferta').hide();
	else
		$('#txtdestaqueoferta').show();
	$('#txtdestaqueoferta').text($('#destaqueoferta').val());	
}

function atualizaPreview(){
	$('#resumoDataHorario').show();

	// alert("test");
			
	if($('.tipoOferta:checked').val()=='po'){		
		var valorSemDesconto = $('#price_field').val();
		
		var discount = $("#discount").val();

		var valorComconto = (valorSemDesconto * discount)/100;
		valorComconto = valorSemDesconto - valorComconto;
		var nomeRestaurante = $('#partner_name').val();
		var nomesProdutos = '';
		$('.tabelaNovaOferta .itemProdutoTabela').each(function() {
			var nomeDesteProduto = $(this).attr('data-nome-produto')+' + ';
			nomesProdutos+= nomeDesteProduto;
		});	
		nomesProdutos = nomesProdutos.substring(0,(nomesProdutos.length - 2));
		nomesProdutos += " no "+nomeRestaurante+".";
		var resultadoFraseOferta = "De R$"+valorSemDesconto+" por R$"+valorComconto+" - "+nomesProdutos+"";
		$('.resultadoInfoOferta').html(resultadoFraseOferta);
		$('.resultadoInfoOferta').show();
	}else if($('.tipoOferta:checked').val()=='co'){		
		var valorSemDesconto = $('#price_field').val();
		var valorComconto = $('#offer_value_field').val();
		var nomeRestaurante = $('#partner_name').val();		
		var resultadoFraseOferta = "Crédito de R$"+valorSemDesconto+" por R$"+valorComconto+" no "+nomeRestaurante+" usar a vontade!";		
		$('.resultadoInfoOferta').html(resultadoFraseOferta);
		$('.resultadoInfoOferta').show();
	}else if($('.tipoOferta:checked').val()=='pco'){
		var valorDescontao = $('#discount').val() + "%";
		var nomeRestaurante = $('#partner_name').val();		
		var resultadoFraseOferta = "Desconto de " +valorDescontao+ " no "+nomeRestaurante+" usar em qualquer produto.";		
		$('.resultadoInfoOferta').html(resultadoFraseOferta);
		$('.resultadoInfoOferta').show();
	}

	if($('#limiteCuponsPorMesa').val()=='sim')
		$('#txtLimiteCupom').show();
	else
		$('#txtLimiteCupom').hide();

	$('.boxDiasSemanaOferta input[type="checkbox"]').each(function() {
		var inputCheck = $(this);
		var valorInputCheck = inputCheck.val();
		if(inputCheck.is(':checked'))
			$('.resumoDataHorario').find('.'+valorInputCheck).show();
		else
			$('.resumoDataHorario').find('.'+valorInputCheck).hide();		
	});
	
 	var inicioHorarioOferta = $('#offer_time_starts_4i').val() + ":" + $('#offer_time_starts_5i').val();
 	var fimHorarioOferta = $('#offer_time_ends_4i').val() + ":" + $('#offer_time_ends_5i').val();
 	$('.resumoDataHorario .horaInicio').text(inicioHorarioOferta);
 	$('.resumoDataHorario .horaFim').text(fimHorarioOferta);
}

function exibeMsgSucesso(){
	$('.adicaoSucesso').show().delay(1500).fadeOut();
}

function marcarProduto(nomeProduto){
	$('#listaProdutos .itemListaProduto').each(function() {
		nomeItem = $(this).children('.infoListaProduto').children('.nomeProduto').text();
		 if(nomeProduto==nomeItem){
		 	$(this).addClass('incluido');
		 }
	});
}

function desmarcarProduto(nomeProduto){
	$('#listaProdutos .itemListaProduto').each(function() {
		nomeItem = $(this).children('.infoListaProduto').children('.nomeProduto').text();
		 if(nomeProduto==nomeItem){
		 	$(this).removeClass('incluido');
		 }
	});
}