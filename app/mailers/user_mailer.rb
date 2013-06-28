# encoding: utf-8
class UserMailer < ActionMailer::Base
  default from: "TrazCupom <trazcupom@trazcupom.com.br>"

  def registration_confirmation(user, password)
    @user = user
    @password = password
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Seja bem vindo ao TrazCupom!")
  end

  def password_reset(user)
    @user = user
    mail :to => "#{user.name} <#{user.email}>", :subject => "Recupere sua senha do TrazCupom"
  end

  def send_new_badge (user, badge)
    @user = user
    @badge = badge
    mail :to => "#{user.name} <#{user.email}>" do |format|
      format.html
    end
    mail :subject => "Parabéns! Voce ganhou uma nova badge: #{badge.name}"
  end

  #Metodo de envio de messagem de email
  #Autor: Paulo Henrique
  def new_message(message)
    @message = message
    mail(:to => "contato@trazcupom.com.br") do |format|
      format.html
    end
    mail :subject => "[Fale Conosco] #{message.subject}"
  end

  #Metodo que envia um confirmação que o email foi enviado
  #Autor: Paulo Henrique Pires
  def new_message_confirmation(message)
    @message = message
    mail(:to => @message.email) do |format|
      format.html
    end
    mail :subject => "Fale Conosco TrazCupom"
  end

  #Metodo de envio de mensagem de email de confirmação de compra de cupom
  def send_offer (cupon)
    user = cupon.user
    @user = cupon.user
    @cupon = cupon
    @rules = Rule.find_by_sql(["SELECT r.*
      FROM rules r, offer_rules of
      WHERE r.id = of.rule_id
      AND of.offer_id = :oid
      AND value > 0
      AND offer_type = :otp", {:oid => @cupon.offer.id, :otp => @cupon.offer.ttype[0]}
    ])
    mail :to => "#{user.name} <#{user.email}>" do |format|
      format.html
    end
    mail :subject => "Compra confirmada com sucesso! #{cupon.offer.resume}."
  end

end