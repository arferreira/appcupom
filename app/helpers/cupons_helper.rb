module CuponsHelper

  def publish_cupon cupon
   if false && (session[:facebook_user]) && current_user.privacy_ids.include?(1)
      offer = cupon.offer
      url = "#{root_url}offers/#{offer.id}"
      graph = session[:facebook_user][:graph]
      options = { :message => "bleh", :description => "blah", :link => url, :picture => "http://dev.trazcupom.com.br/assets/mobile/homescreen-logo.png" }
      options = {
        :name     => "#{offer.resume} em #{offer.company_name}",
        :description => "Cupons exclusivos para usar nesse instante",
        :link        => url,
        :picture     => "http://dev.trazcupom.com.br/assets/mobile/homescreen-logo.png"
      }
      graph.put_connections("me", "#{FacebookAPI.app_namespace}:buy", :offer => url)
      graph.put_wall_post("Acabei de comprar uma oferta no TrazCupom!", options)
    end
  end

  def genCuponCode partner_id, cupon_date
    dateStamp = cupon_date.to_date.year.to_s + "%03d" % cupon_date.to_date.yday.to_s
    modifier = dateStamp[0] +
               dateStamp[2] +
               dateStamp[4] +
               dateStamp[6]

    invert = dateStamp[5] +
             dateStamp[3] +
             dateStamp[1]

    keeper = (modifier.to_i + partner_id).to_s

    codedPartnerDate = keeper[0] +
                       invert[0] +
                       keeper[1] +
                       invert[1] +
                       keeper[2] +
                       invert[2] +
                       keeper[3]


    unique = SecureRandom.hex(2).to_s
    code = unique[0..1] + codedPartnerDate.to_i.to_s(35) + unique[2..4]

    puts "------------------------code = " + code

    code
  end

  def decodeCuponCode code
    dateStamp = Time.now.to_date.year.to_s + "%03d" % Time.now.to_date.yday.to_s
    modifier = dateStamp[0] +
               dateStamp[2] +
               dateStamp[4] +
               dateStamp[6]

    unique = code[0..1] + code[-2..-1]
    codedPartnerDate = code[2..-3].to_i(35).to_s

    keeper = codedPartnerDate[0] +
             codedPartnerDate[2] +
             codedPartnerDate[4] +
             codedPartnerDate[6]

    desinvert = codedPartnerDate[5] +
                codedPartnerDate[3] +
                codedPartnerDate[1]

    partner_id = keeper.to_i - modifier.to_i

    puts "------------------------PartnerID = " + partner_id.to_s

    partner_id
  end

  def isValid?
    true
  end


end
