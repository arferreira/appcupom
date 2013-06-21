# == Schema Information
#
# Table name: offer_rules
#
#  id         :integer(4)      not null, primary key
#  offer_id   :integer(4)
#  value      :integer(4)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  rule_id    :integer(4)
#

class OfferRule < ActiveRecord::Base
  belongs_to :offer
  belongs_to :rule
  
  
  
private
  
  def self.createOrUpdateOfferRuleByOffer offer, values
    rules = Rule.all
    unless rules.nil?
     rules.each do |rule|
       if rule.offer_type == offer.ttype[0]
         offer_rule = offer.offer_rules.find_by_rule_id(rule.id)
         if offer_rule.nil?
           OfferRule.create(:offer_id => offer.id, :rule_id => rule.id, :value => values["rule_#{rule.id}"])
         else
            offer_rule[:value] = values["rule_#{rule.id}"]
            offer_rule.save
         end
       end
     end 
    end
  end
end
