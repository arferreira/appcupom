# encoding: utf-8
# == Schema Information
#
# Table name: timeline_items
#
#  id                      :integer(4)      not null, primary key
#  user_id                 :integer(4)
#  item_type               :string(255)
#  item_count              :integer(4)
#  recommend_partner_id    :integer(4)
#  recommend_product_id    :integer(4)
#  wish_product_id         :integer(4)
#  wish_product_comment_id :integer(4)
#  offer_id                :integer(4)
#  product_id              :integer(4)
#  created_at              :datetime        not null
#  updated_at              :datetime        not null
#  rec_product_comment_id  :integer(4)
#  rec_partner_comment_id  :integer(4)
#  badge_id                :integer(4)
#  friend_id               :integer(4)
#  recommend_offer_id      :integer(4)
#

class TimelineItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :recommend_comment
  belongs_to :recommend_partner
  belongs_to :recommend_product
  belongs_to :recommend_offer
  belongs_to :wish_product
  belongs_to :wish_product_comment
  belongs_to :offer
  belongs_to :product  
  belongs_to :rec_partner_comment
  belongs_to :rec_product_comment
  belongs_to :rec_offer_comment
  belongs_to :badge
  belongs_to :friend, :class_name => "User" 
  has_many :timeline_readers
  #has_many :users, :through => :timeline_readers
  
  #TODO
  type_regex = /OF|PD|WP|WPC|RC|RPT|RPD|RPAC|RPDC|BDG|FRI|RO|ROC/
    
  validates :user_id,  :presence => true
  validates :item_type,  :presence => true,
                         :format     => { :with => type_regex }
  
  #check the types in the class TimelineType in the constant.rb file
  def self.share item_type, user_id, args
    puts args.merge({:item_type => item_type, :user_id => user_id})
    item = TimelineItem.create args.merge({:item_type => item_type, :user_id => user_id})
    
    broadcast item unless item.id.nil?
  end 
  
  def self.broadcast item
    unless item.nil?
      TimelineReader.create :user_id => item.user.id, :timeline_item_id => item.id
      
      item.user.all_friends.each do |reader|
        TimelineReader.create :user_id => reader.id, :timeline_item_id => item.id
      end
    end
  end
  
end
