# encoding: utf-8
# == Schema Information
#
# Table name: categories
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  icon       :string(255)
#

class Category < ActiveRecord::Base
  #relations
  has_many :partners#, through: :partner_categories
  #has_many :partner_categories
  
  
  def self.find_with_product city_id
    # find_by_sql("select distinct categories.* 
                  # from categories 
                  # join partners on categories.id = partners.category_id
                  # join offers on partners.id = offers.partner_id
                  # order by name ")
                  
    Category.find_by_sql(["select distinct categories.*
                        from categories 
                        join partners on categories.id = partners.category_id
                        join offers on partners.id = offers.partner_id
                        where DATE(offers.start_date) <= DATE(:now)
                        and SUBSTRING(recurrence, :daynum, 1) = 1
                        and time_ends > time(date_add(:now_utc, interval 15 minute))
                        and cupon_counter > 0
                        and paused <> 1
                        and offers.active = 1"+
                        ( city_id ? " and partners.city_id = :city " : "" )+
                        "", {:daynum => Time.now.wday + 1, :city => city_id, :now => Time.now, :now_utc => Time.now - 2.hour}])
  end
  
  
  def self.find_with_partner city_id
    Category.find_by_sql(['SELECT distinct categories.*
                           FROM categories 
                           JOIN partners on categories.id = partners.category_id
                          WHERE partners.approved = 1 
                            AND partners.active = 1 
                            AND partners.city_id = :city_id
                       ORDER BY categories.name', {:city_id => city_id}])
  end
  
  
  
end
