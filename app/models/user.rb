# encoding: utf-8
# == Schema Information
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  name                   :string(45)      not null
#  email                  :string(255)     not null
#  dob                    :date
#  gender                 :string(255)
#  active                 :boolean(1)      default(TRUE)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  encrypted_password     :string(255)
#  salt                   :string(255)
#  auth_token             :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer(4)
#  avatar_updated_at      :datetime
#

require 'digest'
class User < ActiveRecord::Base
  include EncryptionHelper
  before_save :encrypt_password
  #Imagen

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>", :small => "23x23>" }
  #Reset Password
  #before_create { generate_token(:auth_token) }

  #relations
  has_many :user_badges, :dependent => :destroy
  has_many :badges, :through => :user_badges
  has_many :offer_comments
  has_many :partner_comments
  has_many :cupons
  has_many :social_links
  has_many :privacies, through: :user_privacies
  has_many :user_privacies
  has_many :user_mail_privacies
  #has_many :recommend_comments, :dependent => :destroy
  #has_many :recommends, :dependent => :destroy
  has_many :recommend_partners, :dependent => :destroy
  has_many :rec_partner_comments, :dependent => :destroy
  has_many :recommend_products, :dependent => :destroy
  has_many :rec_product_comments, :dependent => :destroy
  has_many :wish_products, :dependent => :destroy
  has_many :wish_product_comments, :dependent => :destroy
  has_many :user_cards
  has_many :timeline_readers
  has_many :timeline_items, :through => :timeline_readers
  has_many :user_credits

  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation, :dob, :gender, :avatar, :oauth_token

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i


  validates :name,        :presence   => true,
                          :length     => { :minimum => 6 }

  validates :email,       :presence   => true,
                          :format     => { :with => email_regex },
                          :uniqueness => true,
                          :length     => { :maximum => 100 }

  validates :password,    :presence => true,
                          :confirmation => false,
                          :length => {:within => 6..40},
                          :on => :create

  validates :password, :confirmation => false, :length => { :within => 6..40 }, :on => :update, :unless => lambda{ |user| user.password.blank? }

  #validates_format_of :dob, :with => /\d{2}\/\d{2}\/\d{4}/, :message => "tem o seguinte formato: dd/mm/yyyy"

  #Verify password
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  #return authenticated user
  def self.authenticate(email, submitted_password)
    user = find_by_email_and_active(email, true)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (!user.nil? && user.salt == cookie_salt) ? user : nil
  end

  def access_type
    return USER_TYPE
  end

  #Reset Password
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  #friendship doesn't work NOT USING IT -> use is_my_friend? instead
  #def friend_of?(friend)
  #  Friendship.find_by_friend_id(friend)
  #end

  def friend!(friend)
    Friendship.create!(:friend_id => friend.id)
    true
  rescue ActiveRecord::RecordNotUnique
    @log = 'They are already friends!'
    false
  end

  def unfriend!(friend)
    if self.is_my_friend?(friend)
      @friendship = self.is_my_friend?(friend)
      @friendship.destroy
    end
  end

  def is_my_friend?(friend)
    return Friendship.find_by_me_id_and_friend_id(self.id, friend.id)
  end

  def am_i_a_friend?(friend)
    return Friendship.find_by_me_id_and_friend_id(friend.id, self.id)
  end

  def all_friends
    #Friendship.find_all_by_me_id(self.id)
    User.find_by_sql(['SELECT * FROM users WHERE id IN
                        (SELECT friend_id FROM friendships
                        WHERE me_id = :id AND accepted = 1)',{:id => self.id}])
  end

  def friend_requests
    return User.find_by_sql(['SELECT eu.* FROM friendships f, users eu, users amigo
                           WHERE f.me_id = eu.id
                             AND f.friend_id = amigo.id
                             AND f.friend_id = :id
                             AND (f.facebook_friend = 0 OR f.facebook_friend IS NULL)
                             AND f.me_id NOT IN
                         (SELECT friend_id FROM friendships WHERE me_id = :id)', {:id => self.id}])
  end

  def facebook_friends
    return User.find_by_sql(['SELECT users.* FROM friendships f
                                JOIN users on f.friend_id = users.id
                               WHERE f.me_id = :id
                             		 AND f.facebook_friend = 1
                                 AND f.friend_id NOT IN
                             (SELECT me_id FROM friendships WHERE friend_id = :id)', {:id => self.id}])
  end

  def how_many_friends
    self.all_friends.count
  end

  def friend_timeline_resume user_name, friend_name
    "<b>#{user_name}</b> se conectou com <b>#{friend_name}</b>".html_safe
  end

  def friend_facebook_resume user_name, friend_name
    "#{user_name} se conectou com #{friend_name}".html_safe
  end

  def pay_cupon offer, form_attributes, unique_key
    client = {
							:name => form_attributes[:name],
              :mail => self.email,
              :id => self.id,
              :logradouro => form_attributes[:logradouro],
              :numero => form_attributes[:numero],
              :complemento => form_attributes[:complemento],
              :bairro => form_attributes[:bairro],
              :cidade => form_attributes[:cidade],
              :estado => form_attributes[:estado],
              :pais => "BRA",
              :cep => form_attributes[:cep],
              :telefone_fixo => form_attributes[:telefone]
             }

     args = {
              :razao => "Compra de Cupon",
              :value => offer.nowon_value(self.total_credit_value),
              :id_proprio => unique_key,
              :client => client
            }

      output = MoipHelper.send_payment args
      output
  end

  def create_user_card params
    if self.user_cards.empty?
      UserCard.create_by_params self.id, params
    end
  end

  def cards
    self.user_cards
  end

  def card
    self.user_cards[0]
  end

  def facebook_user
    self.social_links.where(:social_type => "F").first
  end

  def social_allowed? privacy_type
    user_approved = UserPrivacy.find_by_user_id_and_privacy_id(self.id, privacy_type)
    unless user_approved.nil? || facebook_user.nil?
      user_approved.facebook
    else
      false
    end
  end

  def share item_type, args
    TimelineItem.share item_type, self.id, args
  end

  def share_social text, url = "http://www.trazcupom.com", options = {}, privacy_type
    if facebook_user && social_allowed?(privacy_type)
      FacebookGraph.post_message facebook_user.open_graph, text, url, options
    end
  end

  def share_social_partner text, url = "http://www.trazcupom.com", options = {}, privacy_type, partner
    if facebook_user && social_allowed?(privacy_type)
      FacebookGraph.post_message facebook_user.open_graph, text, url, "recommend", "partner", options
    end
  end

  def share_social_voucher text, url = "http://www.trazcupom.com", options = {}, privacy_type, offer
    if facebook_user && social_allowed?(privacy_type)
      FacebookGraph.post_message facebook_user.open_graph, url, "buy", "offer", options
    end
  end

  def total_credit_value
    total = 0
    unless active_credits.nil?
      active_credits.each do |user_credit|
        total += user_credit.current_value
      end
    end

    return total.round(2)
  end

  def active_credits
    UserCredit.where("user_id = ? AND current_value <> 0", self.id)
  end

  def pic size
    if self.avatar?
      self.avatar.url(size)
    elsif !self.social_links.empty?
      self.social_links.first.image_url
    elsif self.gender == "F"
      "/assets/images/avatar-feminino-nowon.jpg"
    else
      "/assets/images/avatar-masculino-nowon.jpg"
    end
  end

  def update_credit discount

    first_active = UserCredit.where("user_id = ? AND current_value <> 0", self.id).order("created_at ASC").first

    if first_active.nil?
      return 0
    else
      if first_active.current_value >= discount
        puts first_active[:current_value] - discount
        first_active[:current_value] = first_active[:current_value] - discount
        first_active.save
      else
        avaliable_value = first_active[:current_value]
        first_active[:current_value] = 0
        first_active.save
        puts avaliable_value
        update_credit discount - avaliable_value
      end
    end
  end

  def first_name
    self.name.split(' ').first
  end

  def products_recommended
    RecommendProduct.find_all_by_user_id(self.id)
  end

  def products_wished
    WishProduct.find_all_by_user_id(self.id)
  end

  def partners_recommended
    RecommendPartner.find_all_by_user_id(self.id)
  end

  #badges
  def has_badge(badge)
    UserBadge.find_by_user_id_and_badge_id(self.id, badge.id)
  end

  def new_badge session
    @badge = Badge.find_by_name('Aprendiz')
    if @badge
      self.mail_badge(@badge, session)
      self.give_credit(5,'Badge ' + @badge.name.to_s)
    end
  end

  def check_bought_cupons (cupon, session)
    @coupons = Cupon.find_by_sql(["SELECT * FROM cupons WHERE user_id = :id AND approved = 1", {:id => self.id}])

    if @coupons.count > 0

      self.check_categories(cupon, session)

      if @coupons.count >= 5
        @iniciante = Badge.find_by_name('Colecionador iniciante')
        p @iniciante
        p self.has_badge(@iniciante)
        if !self.has_badge(@iniciante)
          self.mail_badge(@iniciante, session)
          self.give_credit(5, 'Badge Colecionador iniciante')
        end
      end
      if @coupons.count >= 20
        #@intermediario = Badge.find_by_name('Colecionador intermediário') problema com acento!
        @intermediario = Badge.find(3)
        p @intermediario
        p self.has_badge(@intermediario)
        if !self.has_badge(@intermediario)
          self.mail_badge(@intermediario, session)
          self.give_credit(5, 'Badge Colecionador intermediario')
        end
      end
      if @coupons.count >= 60
        #@avancado = Badge.find_by_name('Colecionador avançado') problema com acento!
        @avancado = Badge.find(4)
        if !self.has_badge(@avancado)
          self.mail_badge(@avancado, session)
          self.give_credit(10, 'Badge Colecionador avancado')
        end
      end
      if @coupons.count >= 100
        @mestre = Badge.find_by_name('Colecionador mestre')
        if !self.has_badge(@mestre)
          self.mail_badge(@mestre, session)
          self.give_credit(20, 'Badge Colecionador mestre')
        end
      end
    end
  end

  #TODO Logica de cupons por categoria, quando chegar a 7 cupon por categoria conceder a badge da categoria
  def check_categories (cupon, session)
    @category = cupon.offer.partner.category

    @count = Cupon.find_by_sql(['select c.*
                                   from cupons c, offers o, partners p, categories t
                                  where c.offer_id = o.id
                                    and o.partner_id = p.id
                                    and p.category_id = t.id
                                    and t.id = :c_id
                                    and c.user_id = :u_id
                                    and c.approved = 1', {:c_id => @category.id, :u_id => self.id}])

    if @count.count >= 7
      @icon = @category.icon
      if @icon == 'arabe'
        @badge = Badge.find(26)
      elsif @icon == 'baiana'
        @badge = Badge.find(16)
      elsif @icon == 'bar'
        @badge = Badge.find(14)
      elsif @icon == 'brasileira'
        @badge = Badge.find(25)
      elsif @icon == 'carnes'
        @badge = Badge.find(39)
      elsif @icon == 'cafeteria'
        @badge = Badge.find(30)
      elsif @icon == 'cervejaria'
        @badge = Badge.find(24)
      elsif @icon == 'chines'
        @badge = Badge.find(22)
      elsif @icon == 'churrascaria'
        @badge = Badge.find(11)
      elsif @icon == 'contemporaneo'
        @badge = Badge.find(35)
      elsif @icon == 'creperia'
        @badge = Badge.find(32)
      elsif @icon == 'espetinho'
        @badge = Badge.find(23)
      elsif @icon == 'frances'
        @badge = Badge.find(13)
      elsif @icon == 'frutos-do-mar'
        @badge = Badge.find(34)
      elsif @icon == 'havaiano'
        @badge = Badge.find(41)
      elsif @icon == 'iogurteria'
        @badge = Badge.find(33)
      elsif @icon == 'indiano'
        @badge = Badge.find(12)
      elsif @icon == 'italiano'
        @badge = Badge.find(18)
      elsif @icon == 'japones'
        @badge = Badge.find(31)
      elsif @icon == 'mediterraneo'
        @badge = Badge.find(19)
      elsif @icon == 'mexicano'
        @badge = Badge.find(40)
      elsif @icon == 'mineira'
        @badge = Badge.find(27)
      elsif @icon == 'natural'
        @badge = Badge.find(36)
      elsif @icon == 'pastelaria'
        @badge = Badge.find(29)
      elsif @icon == 'peruano'
        @badge = Badge.find(38)
      elsif @icon == 'pizzaria'
        @badge = Badge.find(17)
      elsif @icon == 'pub'
        @badge = Badge.find(10)
      elsif @icon == 'risoto'
        @badge = Badge.find(20)
      elsif @icon == 'sanduiche'
        @badge = Badge.find(9)
      elsif @icon == 'self-service'
        @badge = Badge.find(37)
      elsif @icon == 'sorveteria'
        @badge = Badge.find(21)
      elsif @icon == 'tailandes'
        @badge = Badge.find(28)
      elsif @icon == 'temakeria'
        @badge = Badge.find(15)
      end
      #sd('Badge', @badge, 'Has badge? ', has_badge(@badge), 'count', @count)
      if @badge != nil && @badge != ""
        unless has_badge(@badge)
          self.mail_badge(@badge, session)
          self.give_credit(5,'Badge ' + @badge.name.to_s)
        end
      end

    end

  end

  def check_partner_recommendations session
    @recs = RecommendPartner.find_all_by_user_id(self.id)

    if @recs.count >= 20
      @bonvivant = Badge.find_by_name('Colecionador bon vivant')
      if !self.has_badge(@bonvivant)
        self.mail_badge(@bonvivant, session)
      end
    end
  end

  def check_product_recommendations session
    @recs = RecommendProduct.find_all_by_user_id(self.id)

    if @recs.count >= 20
      @degustador = Badge.find_by_name('Colecionador degustador')
      if !self.has_badge(@degustador)
        self.mail_badge(@degustador, session)
      end
    end
  end

  def check_product_wishes session
    @wishes = WishProduct.find_all_by_user_id(self.id)

    if @wishes.count >= 20
      @desejos = Badge.find_by_name('Colecionador de desejos')
      if !self.has_badge(@desejos)
        self.mail_badge(@desejos, session)
      end
    end
  end

  def give_credit(credits, reason)
    @credit = UserCredit.new
    @credit.user = self
    @credit.reason = reason
    @credit.value = credits
    @credit.current_value = credits
    @credit.save
  end

  def mail_badge (badge, session)
    @user_badge = UserBadge.new
    @user_badge.badge = badge
    @user_badge.user  = self

    if @user_badge.save
      @user_badge.user.share TimelineType.badge, {:badge_id => badge.id}
      @user_badge.user.share_social "#{@user_badge.user.name} acaba de conquistar a badge #{badge.name} ", PrivacyType.badge
      UserMailer.send_new_badge(self,badge).deliver
    end
  end

  private

  def check_facebook session
    if session
      fb_link = social_links.where(:social_type => "F").first
      if session[:facebook_user]
        true
      elsif session[:facebook_user].nil? && fb_link
        client = client = Koala::Facebook::API.new(fb_link.access_token)
        credentials = client.get_object("me")
        session[:facebook_user] = {
                                   :username => credentials["username"] || credentials["name"],
                                   :social_type => FacebookAPI.social_type,
                                   :social_id => credentials["id"],
                                   :image_url => client.get_picture(credentials["id"]),
                                   :graph => client
                                  }
        true
      else
        false
      end
    else
      false
    end
  end

end
