# encoding: utf-8
# == Schema Information
#
# Table name: partners
#
#  id                     :integer(4)      not null, primary key
#  company_name           :string(255)     not null
#  trade_name             :string(255)     not null
#  site                   :string(255)
#  email                  :string(255)     not null
#  primary_phone          :string(255)     not null
#  secondary_phone        :string(255)
#  facebook_link          :string(255)
#  twitter_link           :string(255)
#  cnpj                   :integer(4)      not null
#  description            :text
#  foundation             :date
#  latitude               :decimal(15, 10) not null
#  longitude              :decimal(15, 10) not null
#  capacity               :integer(4)      not null
#  active                 :boolean(1)      default(TRUE)
#  approved               :boolean(1)      default(FALSE)
#  administrator_id       :integer(4)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  contact_name           :string(255)
#  has_internet           :boolean(1)
#  client_age             :string(255)
#  average_consumption    :string(255)
#  got_to_know            :string(255)
#  sub_category_id        :integer(4)
#  encrypted_password     :string(255)
#  salt                   :string(255)
#  system_profit          :integer(4)
#  address                :string(255)
#  temp_distance          :string(255)
#  working_schedule       :string(255)
#  city_id                :integer(4)
#  category_id            :integer(4)
#  add_number             :string(255)
#  add_complement         :string(255)
#  add_county             :string(255)
#  add_state              :string(255)
#  cep                    :string(255)
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer(4)
#  avatar_updated_at      :datetime
#  auth_token             :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#

require 'digest'
class Partner < ActiveRecord::Base
  include EncryptionHelper
  before_save :encrypt_password
  before_create { generate_token(:auth_token) }
  
  #Imagen
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>", :small => "23x23>", :perfil => "90x90#" }
  
  #relations
  has_many :products
  has_many :product_types, :dependent => :destroy #sprint001
  has_many :product_families #reunião dia 27/08/2012
  has_many :offers
  has_many :partner_comments
  has_many :partner_pics
  has_many :recommends, :dependent => :destroy
  has_many :recommend_partners, :dependent => :destroy
  
  #habtm
  has_many :categories #, through: :partner_categories
  #has_many :partner_categories
  has_many :facilities, through: :partner_facilities
  has_many :partner_facilities
  has_many :recommendations, through: :partner_recommendations
  has_many :partner_recommendations
  has_many :payment_options, through: :partner_payment_options
  has_many :partner_payment_options
  
  belongs_to :city
  
  
  attr_accessor :password
  attr_accessible :company_name, :email, :password, :password_confirmation, :category_id, :sub_category_id,
                  :trade_name, :contact_name, :site, :primary_phone, :secondary_phone, :facebook_link, 
                  :twitter_link, :cnpj, :foundation, :latitude, :longitude, :capacity, :has_internet, :avatar,
                  :client_age, :average_consumption, :got_to_know, :system_profit, :address, :description, :working_schedule
    
  #habtm              
  attr_accessible :category_ids, :facility_ids, :recommendation_ids, :payment_option_ids
  
  #address              
  attr_accessible :cep, :add_number, :add_complement, :add_county, :city_id, :add_state
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  
  validates :company_name,        :presence   => true,
                                  :length     => { :maximum => 50 , :minimum => 1 }
  
  validates :email,       :presence   => true,
                          :format     => { :with => email_regex },
                          :uniqueness => true,
                          :length     => { :maximum => 100 }
                          
  validates :password,    :presence => true,
                          :confirmation => true,
                          :length => {:within => 6..40},
                          :on => :create                               
  
  
  validates_presence_of :trade_name
  validates_presence_of :primary_phone
  validates_presence_of :cnpj
  validates_presence_of :latitude
  validates_presence_of :longitude
  validates_presence_of :capacity
  validates_presence_of :system_profit
  validates_presence_of :category_id
  validates_presence_of :city_id
  # validates_presence_of :category
 
  
  #Search
  searchable do
    text :company_name, :boost => 5.0
    text :address
    text :description
    integer :id
  end
  
  #Verify password
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  #return authenticated partner
  def self.authenticate(email, submitted_password)
    partner = find_by_email_and_active(email, true)
    return nil if partner.nil?
    return partner if partner.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt) 
    partner = find_by_id(id)
    (!partner.nil? && partner.salt == cookie_salt) ? partner : nil
  end
  
  def access_type
    return PARTNER_TYPE
  end
  
  def name
    self.company_name
  end
  
  def active_products
    self.products.where("active IS NOT NULL AND active = true")
  end
  
  #verify if partner is alredy recommended
  #sprint003
  def recommended? (user)
    RecommendPartner.find_by_user_id_and_partner_id(user.id,self.id)
  end
  
  def not_recommended? (user)
    !self.recommended?(user)
  end
  
  def approve (admin)
    self.administrator_id = admin.id
    self.approved = true
  end
    
  def geo_distance lat2, long2
    lat1 = self.latitude
    long1 = self.longitude
    
    x = radians(long2 - long1) * Math.cos(radians(lat1 + lat2) / 2)
    y = radians(lat2 - lat1)
    
    distance = Math.sqrt(x*x + y*y) * 6371
    distance
  end
  
  def radians degrees 
    degrees * Math::PI / 180
  end
  
  def self.find_local city_id
=begin
    self.find_by_sql(['SELECT partners.*, (select count(*) from recommend_partners WHERE partners.id = recommend_partners.partner_id ) AS count_recom
                         FROM partners
                        WHERE approved = 1 
                          AND city_id = :city_id
                     ORDER BY count_recom DESC', {:city_id => city_id}])
=end
    select("partners.*, (select count(*) from recommend_partners WHERE partners.id = recommend_partners.partner_id ) AS count_recom").
      where(:approved => 1).
      where(:city_id => city_id).
      order("count_recom DESC")
  end 
  
  def self.find_local_with_category city_id, category_id
=begin
    self.find_by_sql(['SELECT partners.*, (select count(*) from recommend_partners WHERE partners.id = recommend_partners.partner_id ) AS count_recom
                         FROM partners
                         JOIN categories on partners.category_id = categories.id 
                        WHERE partners.approved = 1 
                          AND partners.city_id = :city_id
                          AND categories.id = :cat_id
                     ORDER BY count_recom DESC', {:city_id => city_id, :cat_id => category_id }])
=end
    select("partners.*, (select count(*) from recommend_partners WHERE partners.id = recommend_partners.partner_id ) AS count_recom").
      joins("JOIN categories on partners.category_id = categories.id").
      where("partners.approved = 1").
      where("partners.city_id = :city_id", {:city_id => city_id}).
      where("categories.id = :cat_id", {:cat_id => category_id}).
      order("count_recom DESC")
  end 
    
  
  #TODO: return link @estabelecimento se tiver twitter
  # recebe: http://www.twitter.com/fogodechao
  # retorna: @fogodechao (como link)
  def twitter (link)
    link
  end

  #TODO: return link estabelecimento se tiver facebook
  # recebe: http://www.facebook.com/fogodechao
  # retorna: fogodechao (como link)
  def facebook (link)
    link
  end
  
  def active_offers_count
    Offer.find_all_by_partner_id_and_active(self.id, true).size
  end

  def active_offers_now_count
    Offer.where("partner_id = :pid", {:pid => self.id}).
      where(:active => 1).
      where("SUBSTRING(recurrence, :daynum, 1) = 1", {:daynum => Time.now.wday + 1}).
      where("time_starts <= now()").
      where("time_ends >= now()").
      where("start_date <= sysdate()").count
=begin
    Offer.find_by_sql(["SELECT * FROM offers 
                        WHERE partner_id = :pid
                        AND active = 1
                        AND SUBSTRING(recurrence, :daynum, 1) = 1
                        AND time_starts <= now()
                        AND time_ends >= now()
                        AND start_date <= sysdate()",{:pid => self.id, :daynum => Time.now.wday + 1}]).size
=end
  end

  def wishes_count
    WishProduct.count_by_partner self
  end
  
  def self.find_by_position lat, long
    select("p.*,
      @x := RADIANS(#{long} - p.longitude) * COS(RADIANS(p.latitude + #{lat}) / 2) as X,
      @y := RADIANS(#{lat} - p.latitude) as Y,
      ROUND(SQRT(@x * @x + @y * @y) * 6371,2) as temp_distance").
      from("partners p").
      where(:approved => 1).
      order("temp_distance")
=begin
    self.find_by_sql([' SELECT p.*,
                               @x := RADIANS(:long - p.longitude) * COS(RADIANS(p.latitude + :lat) / 2) as X,
                               @y := RADIANS(:lat - p.latitude) as Y,
                               ROUND(SQRT(@x * @x + @y * @y) * 6371,2) as temp_distance
                        FROM partners p
                        WHERE p.approved = 1
                        ORDER BY temp_distance', {:lat => lat, :long => long}])
=end
  end
  
  def self.find_by_position_from_city lat, long, city
=begin
    self.find_by_sql([' SELECT p.*,
                               @x := RADIANS(:long - p.longitude) * COS(RADIANS(p.latitude + :lat) / 2) as X,
                               @y := RADIANS(:lat - p.latitude) as Y,
                               ROUND(SQRT(@x * @x + @y * @y) * 6371,2) as temp_distance
                        FROM partners p
                        WHERE p.city_id = :city
                        and p.approved = 1
                        ORDER BY temp_distance', {:lat => lat, :long => long, :city => city}])
=end
    select("p.*,
      @x := RADIANS(#{long} - p.longitude) * COS(RADIANS(p.latitude + #{lat}) / 2) as X,
      @y := RADIANS(#{lat} - p.latitude) as Y,
      ROUND(SQRT(@x * @x + @y * @y) * 6371,2) as temp_distance").
      from("partners p").
      where("p.city_id = :city", :city => city).
      where("p.approved = 1").
      order("temp_distance")
  end

  def category
    self.category_id.nil? ? nil : Category.find(self.category_id)
  end
  
  def today_offers
    Offer.today_offers_by_partner self.id
  end

  def all_today_offers
    Offer.all_today_offers_by_partner self.id
  end
  
  def week_offers
    Offer.week_offers_by_partner self.id
  end
  
  def product_types
    
  end
  
  def pic size
    if self.avatar?
      self.avatar.url(size)
    else
      "/assets/avatar-generico-now-on.jpg"   
    end
  end
  
  def now_cupons
    Cupon.now_cupons_by_partner self.id
  end
  
  def today_cupons
    Cupon.today_cupons_by_partner self.id
  end
  
  def cupons
    Cupon.find_by_partner_id self.id
  end
  
  def products_rec_count
    count_recs = 0
    self.products.map{|p| count_recs = count_recs + p.recommends_count }
    
    return count_recs 
  end
  
  def offers_rec_count
    count_recs = 0
    self.offers.map{|o| count_recs = count_recs + o.recommends_count }
    
    return count_recs 
  end
  
  def cupons_count
    cupons = Cupon.find_by_sql(["select cupons.*
                            from partners
                            join offers on partners.id = offers.partner_id
                            join cupons on offers.id = cupons.offer_id
                            where partners.id = ?
                            AND cupons.approved = 1", self.id])
                            
    return cupons.size
  end
  
  def investiment
    count_invest = 0.0
    self.offers.map{|o| count_invest = count_invest + o.total_investiment}
    return count_invest 
  end
  
  def profit
    count_profit = 0.0
    self.offers.map{|o| count_profit = count_profit + o.partner_profit}
    return count_profit
  end
  
  def recommendations_count
    @recs = RecommendPartner.find_all_by_partner_id(self.id)
    if @recs.count > 1
      @recs.count.to_s + " Recomendaram"
    elsif @recs.count == 1
      @recs.count.to_s + " Recomendou"
    else
      "Nenhuma Recomendação"
    end
  end
  
  def get_address
    if self.address == nil or self.address == ""
      @address = "Endereço não cadastrado"
    else
      @address = self.address.to_s
      if self.add_number != nil and self.add_number != ""
        @address << ", " << self.add_number.to_s
        if self.add_complement != nil and self.add_complement != ""
          @address << "/" << self.add_complement.to_s unless self.add_complement == nil
        end
      end
      if self.add_county != nil and self.add_county != ""
        @address << " - " << self.add_county.to_s unless self.add_county == nil
      end
    end
    @address
  end
  
  def payment_option_text
    text = ""
    self.payment_options.each_with_index do |po, index|
      
      if index == 0
        text << po.name
      else
        text << ", " << po.name
      end
      
    end
    
    return text
  end
  
  #recuperacao de senha
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    PartnerMailer.partner_password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while Partner.exists?(column => self[column])
  end
  
  #return INT
  def how_many_recommendations
    RecommendPartner.find_all_by_partner_id(self.id).count
  end
  
  #return INT
  def how_many_prods_recommendations
    RecommendProduct.find_by_sql(["SELECT rp.* 
                                  FROM recommend_products rp, partners p, products prod
                                  WHERE prod.partner_id = p.id
                                  AND rp.product_id = prod.id
                                  AND p.id = :id", :id => self.id]).count
  end
  
  #return INT
  def how_many_prods_wishes
    WishProduct.find_by_sql(["SELECT wp.* 
                              FROM wish_products wp, partners p, products prod
                              WHERE prod.partner_id = p.id
                              AND wp.product_id = prod.id
                              AND p.id = :id", :id => self.id]).count
  end
  
#private area  
end
