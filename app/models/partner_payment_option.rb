# == Schema Information
#
# Table name: partner_payment_options
#
#  partner_id        :integer(4)
#  payment_option_id :integer(4)
#

class PartnerPaymentOption < ActiveRecord::Base
  belongs_to :partner
  belongs_to :payment_option
end
