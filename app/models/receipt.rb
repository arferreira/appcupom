# == Schema Information
#
# Table name: receipts
#
#  id            :integer(4)      not null, primary key
#  user_id       :integer(4)
#  offer_id      :integer(4)
#  value         :decimal(8, 2)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  partner_id    :integer(4)
#  description   :string(255)
#  nowon_price   :decimal(8, 2)
#  partner_price :decimal(8, 2)
#  credit        :decimal(8, 2)
#  discount      :integer(4)
#  migrated      :boolean(1)
#

class Receipt < ActiveRecord::Base
  belongs_to :user
  belongs_to :offer
  
  def self.create_by_cupon cupon
    user = cupon.user
    offer = cupon.offer
    Receipt.create :user_id => user.id,
                   :offer_id => offer.id,
                   :partner_id => offer.partner.id,
                   :description => offer.resume,
                   :nowon_price => offer.nowon_price,
                   :partner_price => offer.partner_price,
                   :value => cupon.price,
                   :credit => cupon.credit_discount,
                   :discount => offer.discount
  end
end
