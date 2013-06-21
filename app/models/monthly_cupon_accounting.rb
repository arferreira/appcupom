# == Schema Information
#
# Table name: monthly_cupon_accountings
#
#  id               :integer(4)      not null, primary key
#  month_accounting :string(255)     not null
#  total_value      :integer(10)     not null
#  total_sold       :integer(4)      not null
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

class MonthlyCuponAccounting < ActiveRecord::Base
  #relations
  has_many :cupons
  
end
