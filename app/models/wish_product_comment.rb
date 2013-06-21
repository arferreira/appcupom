# == Schema Information
#
# Table name: wish_product_comments
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)
#  wish_product_id :integer(4)
#  opinion         :text
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class WishProductComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :wish_product
  
  def timeline_resume
    "<b>#{self.user.name}</b> comentou no desejo de <b>#{self.wish_product.user.name}</b>:".html_safe
  end
  
  def facebook_resume
    "#{self.user.name} comentou no desejo de #{self.wish_product.user.name}:".html_safe
  end
end
