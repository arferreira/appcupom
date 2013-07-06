# encoding: utf-8
# == Schema Information
#
# Table name: offers
#
#  id              :integer(4)      not null, primary key
#  partner_id      :integer(4)      not null
#  description     :string(255)
#  discount        :integer(4)
#  price           :decimal(8, 2)
#  time_starts     :time
#  time_ends       :time
#  recurrence      :string(255)
#  active          :boolean(1)      default(TRUE)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  start_date      :datetime
#  ttype           :string(255)
#  partner_pic1_id :integer(4)
#  partner_pic2_id :integer(4)
#  partner_pic3_id :integer(4)
#  main_pic        :integer(4)
#  cupon_counter   :integer(4)
#  temp_distance   :string(255)
#  city_id         :integer(4)
#  daily_cupons    :integer(4)
#

class Offer < ActiveRecord::Base
  default_scope where(:deleted => 0)
  include ActionView::Helpers::NumberHelper

  attr_accessible :end_date, :product_id, :product_qty, :partner_id, :description, :discount, :price, :time_starts, :time_ends, :daily_cupons,:recurrence, :start_date, :ttype, :partner_pic1_id, :partner_pic2_id, :partner_pic3_id, :main_pic, :cupon_counter, :temp_distance, :city_id, :original_price, :paused, :deleted, :company_name,:pic,:attach_file_name, :attach_content_type, :attach_file_size, :attach_updated_at

  attr_accessor :pic_file_name

  belongs_to :partner
  belongs_to :partner_pic1,
             :class_name => "PartnerPic",
             :foreign_key => ":partner_pic1_id"
  #TODO
  belongs_to :partner_pic2,
             :class_name => "PartnerPic",
             :foreign_key => ":partner_pic2_id"
  belongs_to :partner_pic3,
             :class_name => "PartnerPic",
             :foreign_key => ":partner_pic3_id"

  has_many :offer_comments
  has_many :offer_products, :order => "id"
  has_many :products, :through => :offer_products, :order => "offer_products.id"
  has_many :recommend_offers, :dependent => :destroy
  has_many :timeline_items, :dependent => :destroy
  has_many :offer_rules
  has_many :cupons


  days_regex = /[01]+/

  validates :partner_id,        :presence   => true
  validates :daily_cupons,      :presence   => true, :numericality => { :greater_than => 0 }
  validates :cupon_counter,     :presence   => true

  #validates :description,       :length     => { :maximum => 100 }
  #validates :discount,         :numericality => { :greater_than => 0, :less_than_or_equal_to => 100 }

  validates :price,             :numericality => { :greater_than => 0 }

  validates :recurrence,        :format => { :with => days_regex },
                                :length     => { :is => 7 }

  validate :cupon_limit
  validate :min_time
  validate :initial_date, :on => :create
  validate :one_day

  has_attached_file :pic, :styles => {
                            :banner => {
                              :geometry => "273x65#",
                              :quality => 60,
                              :format => "jpg"
                              },
                            :banner_big => {
                              :geometry => "640x222#",
                              :quality => 60,
                              :format => "jpg"
                            },
                            :small => {
                              :geometry => "156x117#",
                              :quality => 60,
                              :format => "jpg"
                            },
                            :thumb => {
                              :geometry => "72x72#",
                              :quality => 60,
                              :format => "jpg"
                            }

                          }
  has_attached_file :attach

  def cupon_limit
    partner = Partner.find partner_id

    unless partner.nil?
      if cupon_counter > partner.capacity * 0.6
        errors[:base] << "Quantidade de vouchers ultrapassa 60% da capacidade do parceiro."
      end
    end
  end

  def min_time
    if (time_ends - time_starts) < 1.hour
      errors[:base] << "A oferta deve durar no mínimo 1 hora."
    end
  end

  def porcentagen_de_desconto
      return 100 - (self.price.to_f / self.original_price.to_f * 100.0).round
  end

  def initial_date
    if start_date.in_time_zone.beginning_of_day < Time.now.in_time_zone.beginning_of_day
      errors[:base] << "A oferta não pode iniciar no passado."
    end
  end

  def one_day
    if recurrence.index('1').nil?
      errors[:base] << "Pelo menos um dia da semana."
    end
  end

  def pic_ids
    pics = []
    pics.push(self.partner_pic1_id) unless self.partner_pic1_id.nil?
    pics.push(self.partner_pic2_id) unless self.partner_pic2_id.nil?
    pics.push(self.partner_pic3_id) unless self.partner_pic3_id.nil?

    pics
  end

  def add_offer_products product_ids_list, product_qty_list
    product_ids_list.each_with_index do |product_id,index|
      OfferProduct.create( :offer_id => self.id, :product_id => product_id, :product_qty => product_qty_list[index] )
    end
  end

  def destroy_offer_products
    OfferProduct.destroy self.offer_products.collect(&:id)
  end

  #Search
  #searchable do
    #text :description
    #text :company_name

    #text :products do
      #products.map(&:name)
    #end

    #text :description, :stored => true
  #end

  def is_product_offer?
    self.ttype == PRODUCT_OFFER
  end

  def is_credit_offer?
    self.ttype == CREDIT_OFFER
  end

  def resume
      #return "De #{number_to_currency(original_price)} por #{number_to_currency(self.price)} " + (self.is_credit_offer? ? "" : "- " << self.get_products_names)
      if self.is_credit_offer?
        @resume = "Crédito de #{number_to_currency(original_price)} por #{number_to_currency(self.price)} para saborear o cardápio"
      else
        @resume = "De #{number_to_currency(original_price)} por #{number_to_currency(self.price)} - " << self.get_products_names
      end
      @resume
  end

  def get_products_names
    productsNames = ""
    self.offer_products.each do |offer_product|
      plural = "(s)" if offer_product.product_qty > 1
      productsNames += "#{offer_product.product_qty} #{offer_product.product.name} + "
    end
    return productsNames[0..-3] if productsNames[-2] == "+"
    return productsNames
  end

  def rules
    Rule.find_all_by_offer_type self.ttype[0]
  end

  def next_ocurrency
    if is_today?
      if is_now?
        next_ocurrency = "Use até #{self.time_ends.strftime("%H:%M")}"
      elsif time_after(self.time_ends, Time.now - 15.minutes)
        next_ocurrency = "Use das #{self.time_starts.strftime("%H:%M")} às #{self.time_ends.strftime("%H:%M")}"
      else
        next_ocurrency = "Use hoje das #{self.time_starts.strftime("%H:%M")} às #{self.time_ends.strftime("%H:%M")}"
      end
    else
      next_ocurrency = "Em breve"
    end

    next_ocurrency
  end

  def period
    "de #{self.time_starts.hour.to_s.rjust(2, "0")}:#{self.time_starts.min.to_s.rjust(2, "0")} ás #{self.time_ends.hour.to_s.rjust(2, "0")}:#{self.time_ends.min.to_s.rjust(2, "0")}"
  end

  def is_now?
    self.is_today? &&
    time_before(self.time_starts, Time.now) && time_after(self.time_ends, Time.now)
  end

  def is_today?
    Time.now >= self.start_date
  end

  def is_full?
    return !(self.cupon_counter > 0)
  end

  def has_day dayNum
    recurrence[dayNum] == 1.to_s
  end

  def days
    days = ""
    index = 0
    recurrence.each_char do |day|
      index = index + 1
      days += "," + I18n.t("form.abbr_day_names.day#{index}") if day == "1"
    end

    return days[1..-1]
  end

  def next_date
    today_day = Time.now.wday
    rest_of_week = self.recurrence[today_day..-1]
    next_day = rest_of_week.index("1")

    #não está no restante da semana
    if next_day.nil?
      next_day = self.recurrence[0..today_day-1].index("1")
    else
      next_day = next_day + (7 - rest_of_week.size)
    end

    diference = -1
    if next_day >= today_day
      diference = next_day - today_day
    else
      diference = 7 - (today_day - next_day)
    end

    return Time.now + diference.days
  end

  def ja_comprou? user
    _user = user.id
    cupon = Cupon.find_on_time_spec user.id
    offer = self

    cupon.map(&:offer_id).each do |comprado|
      if comprado == offer.id
        return false
      end
    end
  end

  def next_date_old
    today_date = Time.now.wday
    index = 0
    next_day = nil
    recurrence.each_char do |day|
      if index == today_date && has_day(index)
        next_day = index
      elsif index < today_date && has_day(index)
        next_day = index
      elsif next_day.nil? && has_day(index)
        next_day = index
      end
      index = index + 1
    end

    if today_date <= next_day
      return Time.now - (today_date - next_day).days
    else
      return Time.now + (next_day - today_date).days
    end
  end

  def pic1
    PartnerPic.find( self.partner_pic1_id ) unless self.partner_pic1_id.nil?
  end

  def genCupon user_id
    Cupon.create :user_id => user_id,
    :offer_id => self.id,
    :recurrence => self.recurrence,
    :validity => self.time_ends,
    :price => self.price,
    :cupon_code => "",
    :monthly_cupon_accounting_id => 1

  end

  def time_before a, b
    a.hour < b.hour ||
    (a.hour == b.hour && a.min < b.min)
  end

  def time_after a, b
    a.hour > b.hour ||
    (a.hour == b.hour && a.min > b.min)
  end

  def self.find_today_by_position lat, long, city_id
    #find_now_by_position(lat, long, city_id) + find_not_now_by_position(lat, long, city_id)
    self.find_by_sql([' SELECT o.*,
                               @x := RADIANS(:long - p.longitude) * COS(RADIANS(p.latitude + :lat) / 2) as X,
                               @y := RADIANS(:lat - p.latitude) as Y,
                               ROUND(SQRT(@x * @x + @y * @y) * 6371,2) as temp_distance
                        FROM offers o
                        JOIN partners p on o.partner_id = p.id
                        WHERE SUBSTRING(recurrence, :daynum, 1) = 1 '+
                        (city_id ? "and p.city_id = :city_id " : "") +
                         'and DATE(o.start_date) <= DATE(:now)
                          and o.time_ends > time(date_add(:now_utc, interval 15 minute))
                          and o.cupon_counter > 0
                          and o.paused <> 1
                          and o.active = 1
                        ORDER BY temp_distance
                        LIMIT :limit', {:limit => 50, :lat => lat, :long => long, :city_id => city_id, :daynum => Time.now.wday + 1, :now => Time.now, :now_utc => Time.now - 2.hour}])
  end

  def self.find_now_by_position lat, long, city_id
    self.find_by_sql([' SELECT o.*,
                               @x := RADIANS(:long - p.longitude) * COS(RADIANS(p.latitude + :lat) / 2) as X,
                               @y := RADIANS(:lat - p.latitude) as Y,
                               ROUND(SQRT(@x * @x + @y * @y) * 6371,2) as temp_distance
                        FROM offers o
                        JOIN partners p on o.partner_id = p.id
                        WHERE SUBSTRING(recurrence, :daynum, 1) = 1 '+
                        (city_id ? "and p.city_id = :city_id " : "") +
                         'and DATE(o.start_date) <= DATE(:now)
                          and o.time_starts <= time(:now_utc)
                          and o.time_ends > time(date_add(:now_utc, interval 15 minute))
                          and o.cupon_counter > 0
                          and o.paused <> 1
                          and o.active = 1
                        ORDER BY temp_distance
                        LIMIT :limit', {:limit => 50, :lat => lat, :long => long, :city_id => city_id, :daynum => Time.now.wday + 1, :now => Time.now, :now_utc => Time.now - 2.hour}])
    #Change limit to offset
  end

  def self.find_not_now_by_position lat, long, city_id
    self.find_by_sql([' SELECT o.*,
                               @x := RADIANS(:long - p.longitude) * COS(RADIANS(p.latitude + :lat) / 2) as X,
                               @y := RADIANS(:lat - p.latitude) as Y,
                               ROUND(SQRT(@x * @x + @y * @y) * 6371,2) as temp_distance
                        FROM offers o
                        JOIN partners p on o.partner_id = p.id
                        WHERE SUBSTRING(recurrence, :daynum, 1) = 1 '+
                        (city_id ? "and p.city_id = :city_id " : "") +
                         'and DATE(o.start_date) <= DATE(:now)
                          and o.time_starts > time(:now_utc)
                          and o.time_ends > time(date_add(:now_utc, interval 15 minute))
                          and o.cupon_counter > 0
                          and o.paused <> 1
                          and o.active = 1
                        ORDER BY temp_distance
                        LIMIT :limit', {:limit => 50, :lat => lat, :long => long, :city_id => city_id, :daynum => Time.now.wday + 1, :now => Time.now, :now_utc => Time.now - 2.hour}])
    #Change limit to offset
  end

  def distance lat, long
    self.partner.geo_distance lat, long
  end

  def last_comment
    offer_comments = self.offer_comments
    unless offer_comments.empty?
      offer_comments[-1]
    else
      nil
    end
  end

  def comments_count
    self.offer_comments.count
  end

  def timeline_resume user_name
    "Acabei de comprar #{self.resume} no <b>#{self.partner.company_name}</b>".html_safe
  end

  def facebook_resume user_name
    "Acabei de comprar #{self.resume} no #{self.partner.company_name}"
  end

  def nowon_price
    # (self.price * (self.partner.system_profit/100.0 )).round(2)
    # ((self.price * (1+(self.discount/100.0)))/10.0).ceil.round(2)
    (self.original_price/10.0).ceil.round(2)
  end

  def partner_price
    (self.price - self.nowon_price).round(2)
  end

  def avaliable_credit_value total_credit
    (total_credit > nowon_price ? nowon_price : total_credit)
  end

  def total_investiment
    cupons_list = Cupon.find_all_by_offer_id_and_validated(self.id, true)
    return (cupons_list.count * self.original_price * self.discount/100.0).round(2)
  end

  def total_profit
    cupons_list = Cupon.find_all_by_offer_id_and_validated(self.id, true)
    return cupons_list.count * self.price
  end

  def partner_profit
    cupons_list = Cupon.find_all_by_offer_id_and_validated(self.id, true)
    return cupons_list.count * self.partner_price
  end

  def nowon_value total_credit
    self.nowon_price - avaliable_credit_value(total_credit)
  end

  def cupons_count
    cupons = Cupon.find_by_sql(["select cupons.*
                            FROM offers
                            join cupons on offers.id = cupons.offer_id
                            where offers.id = ?
                            AND cupons.approved = 1", self.id])

    return cupons.size
  end

  def self.now_offers city_id = nil
      Offer.find_by_sql(["select offers.*, (select count(*) from cupons where offer_id = offers.id and DATE(cupons.good_date) = DATE(:now)) as count_cupons
                          from offers
                          join partners on offers.partner_id = partners.id
                          where DATE(start_date) <= DATE(:now)
                          and DATE(:today) between DATE(start_date) and DATE(end_date)
                          and time_starts <= time(:now_utc)
                          and time_ends > time(date_add(:now_utc, interval 15 minute))
                          and cupon_counter > 0
                          and offers.paused <> 1
                          and offers.active = 1"+
                          (city_id ? " and partners.city_id = :city " : "" )+
                          " order by count_cupons desc", {:today => Date.today,:daynum => Time.now.wday + 1, :city => city_id, :now => Time.now, :now_utc => Time.now - 2.hour}])
  end

  def self.not_now_offers city_id = nil
      Offer.find_by_sql(["select offers.*, (select count(*) from cupons where offer_id = offers.id) as count_cupons
                          from offers
                          join partners on offers.partner_id = partners.id
                          where DATE(start_date) <= DATE(:now)
                          and DATE(:today) between DATE(start_date) and DATE(end_date)
                          and time_starts > time(:now_utc)
                          and time_ends > time(date_add(:now_utc, interval 15 minute))
                          and cupon_counter > 0
                          and offers.paused <> 1
                          and offers.active = 1"+
                          ( city_id ? " and partners.city_id = :city " : "") +
                          " order by count_cupons desc", {:today => Date.today,:daynum => Time.now.wday + 1, :city => city_id, :now => Time.now, :now_utc => Time.now - 2.hour}])
  end

  def self.today_offers city_id = nil
      Offer.find_by_sql(["select offers.*, (select count(*) from cupons where offer_id = offers.id and DATE(cupons.good_date) = DATE(:now)) as count_cupons
                          from offers
                          join partners on offers.partner_id = partners.id
                          where DATE(start_date) <= DATE(:now)
                          and DATE(:today) between DATE(start_date) and DATE(end_date)
                          and time_ends > time(date_add(:now, interval 15 minute))
                          and cupon_counter > 0
                          and offers.paused <> 1
                          and offers.active = 1"+
                          ( city_id ? " and partners.city_id = :city " : "" )+
                          " order by count_cupons desc", {:today => Date.today,:daynum => Time.now.wday + 1, :city => city_id, :now => Time.now - 2.hour}])
  end

  def self.find_by_partner_category city_id = nil, category_id
    Offer.find_by_sql(["select offers.*, (select count(*) from cupons where offer_id = offers.id and DATE(cupons.good_date) = DATE(:now)) as count_cupons
                          from offers
                          join partners on offers.partner_id = partners.id
                          where partners.category_id = :category_id
                          and DATE(:today) between DATE(start_date) and DATE(end_date)
                          and DATE(start_date) < DATE(:now)
                          and SUBSTRING(recurrence, :daynum, 1) = 1
                          and time_ends > time(date_add(:now_utc, interval 15 minute))
                          and cupon_counter > 0
                          and offers.paused <> 1
                          and offers.active = 1"+
                          ( city_id ? " and partners.city_id = :city " : "" )+
                          " order by count_cupons desc", {:today => Date.today, :daynum => Time.now.wday + 1, :city => city_id, :category_id => category_id, :now => Time.now, :now_utc => Time.now - 2.hour }])
  end

  def self.now_offers_by_partner partner_id
      Offer.find_by_sql(["select *
                          from offers
                          where partner_id = :partner_id
                          and DATE(start_date) <= DATE(:now)
                          and DATE(:today) between DATE(start_date) and DATE(end_date)
                          and time_starts <= time(:now_utc)
                          and cupon_counter > 0
                          and paused <> 1
                          and time_ends > time(date_add(:now_utc, interval 15 minute))
                          and active = 1", {:today => Date.today, :daynum => Time.now.wday + 1, :partner_id => partner_id, :now => Time.now, :now_utc => Time.now - 2.hour}])
  end

  def self.all_today_offers_by_partner partner_id
    Offer.find_by_sql(["select *
                        from offers
                        where partner_id = :partner_id
                        and DATE(:today) between DATE(start_date) and DATE(end_date)
                        and DATE(start_date) <= DATE(:now)
                        and cupon_counter > 0
                        and time_ends > time(date_add(:now_utc, interval 15 minute))
                        and active = 1", {:today => Date.today, :partner_id => partner_id, :daynum => Time.now.wday + 1, :now => Time.now, :now_utc => Time.now - 2.hour}])
  end

  def self.today_offers_by_partner partner_id
    Offer.find_by_sql(["select *
                        from offers
                        where partner_id = :partner_id
                        and DATE(:today) between DATE(start_date) and DATE(end_date)
                        and DATE(start_date) <= DATE(:now)
                        and cupon_counter > 0
                        and paused <> 1
                        and time_ends > time(date_add(:now_utc, interval 15 minute))
                        and active = 1", {:today => Date.today,:partner_id => partner_id, :daynum => Time.now.wday + 1, :now => Time.now, :now_utc => Time.now - 2.hour}])
  end


  def self.week_offers_by_partner partner_id
      Offer.find_by_sql(["select *
                          from offers
                          where
                          partner_id = :partner_id
                          and DATE(:today) between DATE(start_date) and DATE(end_date)
                          and DATE(start_date) <= DATE(:now)
                          and active = 1" , {:today => Date.today,:partner_id => partner_id, :daynum => Time.now.wday + 1, :now => Time.now }])
  end

  def recommends_count
     self.recommend_offers.count
  end

  def self.offers_by_date date
    Offer.find_by_sql(["SELECT * FROM offers
                        WHERE SUBSTRING(recurrence, :daynum, 1) = 1
                        AND start_date <= :date
                        AND active = 1", {:daynum => date.wday + 1, :date => date}])

  end

end
