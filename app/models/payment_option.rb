# encoding: utf-8
# == Schema Information
#
# Table name: payment_options
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class PaymentOption < ActiveRecord::Base
  #relations
  has_many :partners, through: :partner_payment_options
  has_many :partner_payment_options
end
