# == Schema Information
#
# Table name: friendships
#
#  id              :integer(4)      not null, primary key
#  me_id           :integer(4)
#  friend_id       :integer(4)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  accepted        :boolean(1)
#  facebook_friend :boolean(1)
#

class Friendship < ActiveRecord::Base
  attr_accessible :friend_id
  
  belongs_to :me, :class_name => "User"
  belongs_to :friend, :class_name => "User"
  
  validates :me_id,  :presence => true
  validates :friend_id,  :presence => true
  
  
  def self.friend me, user, is_facebook
    friendship = find_by_me_id_and_friend_id(me.id, user.id)
    
    friendship ||= Friendship.new
    friendship.me_id = me.id
    friendship.friend_id = user.id

    #estou aprovando uma solicitacao?
    known = me.am_i_a_friend?(user) 
    if known 
      friendship.accepted = true
      known.accepted = true
      known.save
    else #estou adicionando a pessoa e não aceitando a solicitação de amizade
      if is_facebook
        if friendship.id.nil?
          friendship.facebook_friend = true
        end
      elsif friendship.facebook_friend?
        friendship.facebook_friend = false
      else
        friendship.accepted = false
      end
    end
    
    return friendship.save
  end
  
   
end
