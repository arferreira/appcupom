class PartnerMailer < ActionMailer::Base
  default from: "TrazCupom <contato@ifollowagencia.com.br>"

  def registration_confirmation(partner)
    @partner = partner

    mail(:to => "#{partner.name} <#{partner.email}>", :subject => "Cadastrado!")
  end

  def partner_password_reset(partner)
    @partner = partner
    mail :to => "#{partner.name} <#{partner.email}>", :subject => "Recupere sua senha do TrazCupom"
  end

  def partner_send_offer cupon, offer
    user = cupon.user
    @offer = offer
    @user = cupon.user
    @cupon = cupon
    
    mail :to => "#{@offer.company_name} <#{@offer.email}>" do |format|
      format.html
    end
    mail :subject => "Uma compra realizada no TrazCupom: #{cupon.offer.resume}."
  end
end
