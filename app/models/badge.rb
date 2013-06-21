# == Schema Information
#
# Table name: badges
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)     not null
#  description :text            default(""), not null
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  icon        :string(255)
#

class Badge < ActiveRecord::Base
  
  #relations
  has_many :user_badges
  has_many :users, :through => :user_badges
  
  def has_badge(user)
    if UserBadge.find_by_user_id_and_badge_id(user.id, self.id)
      "badge-on #{self.icon}"
    else
      "badge-off"
    end
  end

  # Metodo que envia badge por email
  # author: Paulo Henrique
  # Data: 09/11/2012
  def has_badge_email(user)
    if UserBadge.find_by_user_id_and_badge_id(user.id, self.id)
      "#{self.icon}"
    else
      "badge-off"
    end
  end
  
  def timeline_resume user_name
    "<b>#{user_name}</b> ganhou a badge <b>#{self.name}</b>".html_safe
  end
  
  def facebook_resume user_name
    "#{user_name} ganhou a badge #{self.name}"
  end
  
end
