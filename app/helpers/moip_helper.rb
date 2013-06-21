module MoipHelper
  include HTTParty
  
  def self.send_payment attributes
    send_xml xml_transparent_payment attributes
  end

  
  def self.send_xml xml
      key = Base64.strict_encode64(Moip.token+":"+Moip.secret)

      args = {
        :body => xml, #ic.iconv(xml),
        :headers => {
                      "Content-Type" => "application/xml",
                      "Authorization" => "Basic #{key}"
                    }
      }
      
      response = self.post(Moip.url, args)
      response = response.parsed_response
     
      puts "Teste debug moip_2"
      puts response
      puts "-----------------------------------"
      puts "-----------------------------------"
      puts "-----------------------------------"
      puts "-----------------------------------"
      puts "-----------------------------------"
     
      if !response.nil? && !response["ns1:EnviarInstrucaoUnicaResponse"].nil? && response["ns1:EnviarInstrucaoUnicaResponse"]["Resposta"]["Status"] != "Falha"
        { :id => response["ns1:EnviarInstrucaoUnicaResponse"]["Resposta"]["ID"],
          :transaction_token => response["ns1:EnviarInstrucaoUnicaResponse"]["Resposta"]["Token"]
        }      
      elsif !response.nil? && !response["EnviarInstrucaoUnicaResponse"].nil? && response["EnviarInstrucaoUnicaResponse"]["Resposta"]["Status"] != "Falha"
        { :id => response["EnviarInstrucaoUnicaResponse"]["Resposta"]["ID"],
          :transaction_token => response["EnviarInstrucaoUnicaResponse"]["Resposta"]["Token"]
        }
      else
        nil
      end
     
  end
  
  def self.xml_transparent_payment attributes
    builder = Nokogiri::XML::Builder.new(:encoding => "UTF-8") do |xml|
          # Identificador do tipo de instrução
      xml.EnviarInstrucao{
        xml.InstrucaoUnica(:TipoValidacao => "Transparente"){
              xml.Razao{
                xml.text attributes[:razao]
              }
              xml.Valores{
                  xml.Valor(:moeda => "BRL"){
                    xml.text attributes[:value]
                  }
              }
              xml.IdProprio{
                xml.text attributes[:id_proprio]
              }
              xml.Pagador{
                  xml.Nome{
                      xml.text attributes[:client][:name]
                  }
                  xml.Email{
                      xml.text attributes[:client][:mail]
                  }
                  xml.IdPagador{ 
                      xml.text attributes[:client][:id]
                  }
                  xml.EnderecoCobranca{
                      xml.Logradouro{
                          xml.text attributes[:client][:logradouro]
                      }
                      xml.Numero{
                          xml.text attributes[:client][:numero]
                      }
                      xml.Complemento{
                          xml.text attributes[:client][:complemento]
                      }
                      xml.Bairro{
                          xml.text attributes[:client][:bairro]
                      }
                      xml.Cidade{
                          xml.text attributes[:client][:cidade]
                      }
                      xml.Estado{
                          xml.text attributes[:client][:estado]
                      }
                      xml.Pais{
                          xml.text attributes[:client][:pais]
                      }
                      xml.CEP{
                          xml.text attributes[:client][:cep]
                      }
                      xml.TelefoneFixo{
                          xml.text attributes[:client][:telefone_fixo]
                      }
                  }
              }
              # xml.Parcelamentos{
                  # xml.Parcelamento{
                      # xml.MinimoParcelas{
                          # xml.text "2"
                      # }
                      # xml.MaximoParcelas{
                          # xml.text "2"
                      # }
                      # xml.Juros{
                          # xml.text "1.99"
                      # }
                  # }
              # }
          }
      }
    end
    builder.to_xml

  end
end
