# encoding: utf-8
# == Schema Information
#
# Table name: rules
#
#  id          :integer(4)      not null, primary key
#  description :string(255)
#  offer_type  :string(255)
#  ttype       :string(255)
#  default     :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Rule < ActiveRecord::Base
  has_many :offer_rules
  
  validates :description,        :presence   => true
  validates :resume,             :presence   => true
  validates :offer_type,         :presence   => true
  validates :ttype,              :presence   => true
  
  
  def isProductRule?
    self.offer_type == PRODUCT_RULE
  end
  
  def isCreditRule?
    self.offer_type == CREDIT_RULE
  end
  
  def offer_value offer_id
    o_rule = OfferRule.find_by_rule_id_and_offer_id(self.id, offer_id)
    
    unless o_rule.nil?
      return o_rule.value
    end
  end
  
  def get_offer_rule offer
    OfferRule.find_by_offer_id_and_rule_id(offer.id, self.id)
  end
  
  def resume_text offer
    @or = get_offer_rule offer
    @return = ""
    
    if self.ttype == "QL"
      @return << self.resume
    else
      @return << self.resume
      @return = @return.gsub("#",@or.value.to_s)
    end
    @return
  end
  
end
