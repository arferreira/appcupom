class Cupon < ActiveRecord::Base
  include CuponsHelper
  after_create :gen_code

  #relations
  belongs_to :user
  belongs_to :offer
  belongs_to :monthly_cupon_accounting
  attr_accessible :user_id, :offer_id, :price, :credit_discount, :good_date, :cupon_code, :monthly_cupon_accounting_id, :transaction_id, :nasp_key,:approved, :moip_status

  def gen_code
    unless self.offer.nil?
      self.cupon_code = genCuponCode(self.offer.partner.id, Time.now).upcase
    self.save
    end
  end

  def self.find_today_by_partner partner_id
    find_by_sql(["select cupons.*
                  from partners
                  join offers on partners.id = offers.partner_id
                  join cupons on offers.id = cupons.offer_id
                  where partners.id = ?
                  and validated = true
                  AND cupons.approved = 1
                  and DATE(cupons.validated_date) = DATE(?)", partner_id, Time.now])
  end

  def self.find_on_time user_id
    find_by_sql(["SELECT cupons.*
                  FROM cupons
                  JOIN offers ON cupons.offer_id = offers.id
                  WHERE cupons.user_id = ?
                  AND cupons.good_date >= DATE(?)
                  AND cupons.moip_status != 'Iniciado'
                  and offers.time_ends > time(?)
                  ORDER BY cupons.created_at", user_id, Time.now - 2.hour, Time.now - 2.hour])
  end

  def self.find_old_ones user_id
    find_by_sql(["SELECT *
                  FROM cupons
                  WHERE user_id = ?
                  AND cupons.moip_status != 'Iniciado'
                  ORDER BY cupons.created_at", user_id])
  end

  def formatted_date
    #self.created_at.mday.to_s << "/" << self.created_at.month.to_s << "/" << self.created_at.year.to_s <<
    #" " << self.created_at.hour.to_s << ":" << self.created_at.minute.to_s
    self.created_at.strftime("%d/%m/%Y %H:%M")
  end

  def self.now_cupons_by_partner partner_id
      find_by_sql(["select cupons.*
                    from offers
                    join cupons on offers.id = cupons.offer_id
                    where offers.partner_id = :partner_id
                    and offers.start_date <= DATE(:now)
                    and SUBSTRING(offers.recurrence, :daynum, 1) = 1
                    and offers.time_starts <= time(:now_utc)
                    and offers.time_ends > time(:now_utc)
                    and offers.active = 1
                    and cupons.approved = 1
                    and cupons.good_date = DATE(:now_utc)
                    order by cupons.validated desc", {:daynum => Time.now.wday + 1, :partner_id => partner_id, :now => Time.now, :now_utc => Time.now - 2.hour}])
                    # and cupons.good_date = DATE(sysdate())
  end

                    # AND ((TIME(NOW()) > STR_TO_DATE('22:00:00','%H:%i:%s')
                        # and cupons.good_date = date(DATE_ADD(now(), INTERVAL 1 DAY)))
                        # OR(TIME(NOW()) < STR_TO_DATE('02:00:00','%H:%i:%s')
                        # and cupons.good_date = date(DATE_SUB(now(), INTERVAL 1 DAY)) )
                        # OR  (time(cupons.created_at) >=  STR_TO_DATE('02:00:00','%H:%i:%s')
                        # and cupons.good_date = DATE(now())))



  def self.today_cupons_by_partner partner_id
     find_by_sql(["select cupons.*
                  from offers
                  join cupons on offers.id = cupons.offer_id
                  where offers.partner_id = :partner_id
                  and DATE(offers.start_date) <= DATE(:now)
                  and SUBSTRING(offers.recurrence, :daynum, 1) = 1

                  AND ((TIME(:now) > STR_TO_DATE('22:00:00','%H:%i:%s')
                  and cupons.good_date = date(DATE_ADD(:now, INTERVAL 1 DAY)))
                  OR(TIME(:now) < STR_TO_DATE('02:00:00','%H:%i:%s')
                  and cupons.good_date = date(DATE_SUB(:now, INTERVAL 1 DAY)) )
                  OR  (time(cupons.created_at) >=  STR_TO_DATE('02:00:00','%H:%i:%s')
                  and cupons.good_date = DATE(:now)))

                  and approved = 1
                  order by cupons.validated desc", {:daynum => Time.now.wday + 1, :partner_id => partner_id, :now_utc => Time.now - 2.hour, :now => Time.now}])
                        # and cupons.good_date = DATE(sysdate())
  end

  def self.find_by_partner_id partner_id
    find_by_sql(["select cupons.*
                  from partners
                  join offers on partners.id = offers.partner_id
                  join cupons on offers.id = cupons.offer_id
                  where partners.id = ?
                  and cupons.approved = 1", partner_id])
  end

  def code_or_status
    out = self.cupon_code.upcase
    out = self.moip_status if self.moip_status != "Autorizado"

    return out
  end

end
