# encoding: utf-8
# == Schema Information
#
# Table name: products
#
#  id                :integer(4)      not null, primary key
#  name              :string(255)     not null
#  description       :text
#  price             :decimal(10, 2)  not null
#  active            :boolean(1)      default(TRUE)
#  partner_id        :integer(4)      not null
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  product_family_id :integer(4)
#  product_type_id   :integer(4)
#

class Product < ActiveRecord::Base
  #relations
  belongs_to :partner
  belongs_to :product_type # Change da reuinão 27/08/2012
  belongs_to :product_family # Change da reuinão 27/08/2012
  has_many :offer_products
  has_many :offers, :through => :offer_products
  has_many :recommend_products, :dependent => :destroy
  has_many :wish_products, :dependent => :destroy
  
  validates :name,          :presence   => true
  #?validates :description,   :presence   => true ????????
  validates :price,         :presence   => true
  validate :or_category_family, :has_active_offer_on_price_change

  @has_active_offer = false
  
  def or_category_family
    if (product_family_id.blank? && product_type_id.blank?)
        errors[:base] << "Categoria e Familia de produtos não podem ser vazios ao mesmo tempo"
    end
  end
  
  
  def self.calculate_price prods_id_list
    unless prods_id_list.nil?
       #Product.where("id in (#{prods_id_list.to_s[1..-2]})").sum(:price)
       Product.sum(:price, :conditions => "id IN (#{prods_id_list.to_s[1..-2]})")
    else
       0
    end
  end
  
  #verify if partner is alredy recommended
  #sprint003
  def recommended? (user)
    RecommendProduct.find_by_user_id_and_product_id(user.id,self.id)
  end
  
  def not_recommended? (user)
    !self.recommended?(user)
  end
  
  def wished? (user)
    WishProduct.find_by_user_id_and_product_id(user.id,self.id)
  end
  
  def not_wished? (user)
    !self.wished?(user)
  end
 
 def recommends_count
   self.recommend_products.count
 end
 
 def active?
   Product.find(self.id).active
 end

  #update offer prices whenever product price is updated
  def price=(price)
    @has_active_offer = false
    unless price == read_attribute(:price)
      @has_active_offer = !((offer_ids & Offer.today_offers.map(&:id)).blank?)
      unless @has_active_offer
        offer_products.each do |op|
          o = op.offer
          if o
            original_price = o.original_price
            original_price -= read_attribute(:price) * op.product_qty
            original_price += price.to_f * op.product_qty
            nowon_discount = (original_price/10.0).ceil
            o.price = original_price * (1 - (o.discount)/100.0) + nowon_discount
            o.original_price = original_price
            #raise [orip.to_f, orid.to_f, price.to_f, p1.to_f,p2.to_f,p3.to_f,p4.to_f,p5.to_f].inspect
            o.save
          end
        end
      end
      write_attribute(:price, price.to_f)
    end
  end

  def has_active_offer_on_price_change
    if @has_active_offer
      errors.add(:price, "Há uma oferta ativa com este produto, desative-a antes de alterar o preço!")
    end
  end
end
