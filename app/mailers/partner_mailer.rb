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
end
