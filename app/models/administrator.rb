# == Schema Information
#
# Table name: administrators
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)     not null
#  email              :string(255)     not null
#  admin_role_id      :integer(4)      not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  encrypted_password :string(255)
#  salt               :string(255)
#

class Administrator < ActiveRecord::Base
  include EncryptionHelper
  before_save :encrypt_password
  
  #relations
  belongs_to :admin_role
  has_many :partners
  
  
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation, :admin_role_id
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  
  validates :name,        :presence   => true,
                          :length     => { :maximum => 50 , :minimum => 6 }
  
  validates :email,       :presence   => true,
                          :format     => { :with => email_regex },
                          :uniqueness => true,
                          :length     => { :maximum => 100 }
                          
  validates :password,    :presence => true,
                          :confirmation => true,
                          :length => {:within => 6..40} 
                          
  validates :admin_role_id,    :presence => true                         
  
  
  
  #Verify password
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  #return authenticated user
  def self.authenticate(email, submitted_password)
    admin = find_by_email(email)
    return nil if admin.nil?
    return admin if admin.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt) 
    admin = find_by_id(id)
    (admin && admin.salt == cookie_salt) ? admin : nil
  end
  
  def access_type
    return ADMIN_TYPE
  end
  
  
end
