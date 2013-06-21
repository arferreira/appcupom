# encoding: utf-8
# == Schema Information
#
# Table name: product_families
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  partner_id      :integer(4)
#  product_type_id :integer(4)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  active          :boolean(1)      default(TRUE)
#

# Classe criada para agrupar produtos iguais porem
# com detalhes diferentes
# Ex.: Produto Pizza Calabreza Grande e Produto Pizza Calabresa Média pertence a Familia de Produto Pizza Calabresa que pertence ao tipo de produto Pizza
class ProductFamily < ActiveRecord::Base
  #relations
  belongs_to :partner
  belongs_to :product_type
  has_many :products, :dependent => :destroy
  
  validates :product_type_id,        :presence   => true
  validates :name,        :presence   => true
  
  attr_accessible :name, :id, :partner_id, :product_type_id, :public
  
  def get_prods (partner, category)
    Product.find_all_by_product_family_id_and_product_type_id_and_partner_id(self.id, category.id, partner.id)
  end
  
  def get_active_prods
    Product.find_all_by_product_family_id_and_active(self.id, true)
  end

  def has_prods?
    Product.find_by_product_family_id(self.id)
  end
  
  def expensive_product
    Product.find_by_sql(["SELECT *
                         FROM products
                         WHERE product_family_id = :id
                         AND active = 1
                         ORDER BY price DESC", {:id => self.id}]).first  
  end
  
  def ok_to_destroy
    @product        = self.get_active_prods.count
    
    if (@product > 0)
      @alert = 'Cagtegoria não pode ser desativada. Existe produto vinculado a esta categoria!'
    else
      @alert = 'OK'
    end
    @alert
  end
  
  def ok_to_destroy?
    self.ok_to_destroy == 'OK'
  end
end
