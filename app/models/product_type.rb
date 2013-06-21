# encoding: utf-8
# == Schema Information
#
# Table name: product_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  partner_id :integer(4)
#  public     :boolean(1)
#  active     :boolean(1)      default(TRUE)
#

class ProductType < ActiveRecord::Base
  #relations
  has_many :products        # Change da reuinão 27/08/2012
  has_many :product_families, :dependent => :destroy  # Change da reuinão 27/08/2012
  belongs_to :partner #sprint001
  
  validates :name,        :presence   => true
  
  attr_accessible :name, :id, :partner_id, :public
  
  def get_fam (partner)
    # BUG 150 Botelho nao quer essa logica sensacional... uma pena
    #@return = []
    @fam = ProductFamily.find_all_by_product_type_id_and_partner_id(self.id, partner.id)
    #@fam.map{|x| x.has_prods? ? @return << x : @return }
    
    #@return
  end

  def get_active_product_families
    @fam = ProductFamily.find_all_by_product_type_id_and_active(self.id, true)
  end

  def get_active_prods
    Product.find_all_by_product_type_id_and_active(self.id, true)
  end

  def get_prods_with_n_fam (partner)
    Product.find_all_by_product_type_id_and_partner_id_and_product_family_id(self.id, partner.id, nil)
  end
  
  def get_active_prods_with_n_fam (partner)
    Product.find_all_by_product_type_id_and_partner_id_and_product_family_id_and_active(self.id, partner.id, nil, true)
  end
  
  def ok_to_destroy
    @product_family = self.get_active_product_families.count
    @product        = self.get_active_prods.count
    
    if (@product_family > 0)
      @alert = 'Cagtegoria não pode ser desativada. Existe familia de produto vinculado a esta categoria!'
    elsif (@product > 0)
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
