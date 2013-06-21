# == Schema Information
#
# Table name: offer_products
#
#  product_id  :integer(4)      not null
#  offer_id    :integer(4)      not null
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  product_qty :integer(4)
#  id          :integer(4)      not null, primary key
#

class OfferProduct < ActiveRecord::Base
  #relations
  belongs_to :product
  belongs_to :offer
  
  
  
  def price
    self.product_qty * self.product.price
  end
end
