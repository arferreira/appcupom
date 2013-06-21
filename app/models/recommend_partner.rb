# encoding: utf-8
# == Schema Information
#
# Table name: recommend_partners
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  partner_id :integer(4)
#  opinion    :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class RecommendPartner < ActiveRecord::Base
  belongs_to :user
  belongs_to :partner
  
  has_many :rec_partner_comments, :dependent => :destroy
  
  attr_accessible :id, :user_id, :partner_id, :opinion
  
  # Params: partner_id, current_user_id
  # Returns: Partner Recommandations from current users friends
  #          If there's none Returns FALSE
  def self.find_by_friendship (partner_id, cur_user)
    RecommendPartner.find_by_sql(['SELECT * FROM recommend_partners WHERE partner_id = :pid
                                     AND (user_id IN (
                                    SELECT eu.id FROM friendships f, users eu, users amigo
                                     WHERE f.me_id = eu.id AND f.friend_id = amigo.id 
                                       AND f.friend_id = :uid AND f.me_id IN
                                       (SELECT friend_id FROM friendships WHERE me_id = :uid))
                                        OR user_id = :uid)', {:pid => partner_id, :uid => cur_user}])
  end
  
  
  def last_comment
    rec_comments = self.rec_partner_comments
    unless rec_comments.empty?
      rec_comments[-1]
    else
      nil
    end
  end
  
  def comments_count
    self.rec_partner_comments.count
  end
  
  def timeline_resume
    "<b>#{self.user.name}</b> recomendou o estabelecimento <b>#{self.partner.company_name}</b>: #{self.opinion}".html_safe
  end
  
  def facebook_resume
    "#{self.user.name} recomendou o estabelecimento #{self.partner.company_name}: #{self.opinion}"
  end
end
