# == Schema Information
#
# Table name: user_cards
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  card_flag_id :integer(4)
#  secure_code  :string(255)
#  logradouro   :string(255)
#  numero       :string(255)
#  complemento  :string(255)
#  bairro       :string(255)
#  cidade       :string(255)
#  estado       :string(255)
#  cep          :string(255)
#  telefone     :string(255)
#  key          :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  name         :string(255)
#  card_number  :string(255)
#  cpf          :string(255)
#  birthdate    :string(255)
#  save_card    :boolean(1)
#

class UserCard < ActiveRecord::Base
  belongs_to :user
  belongs_to :card_flag
  
  validates_presence_of :user_id
  validates_presence_of :logradouro
  validates_presence_of :numero
  validates_presence_of :bairro
  validates_presence_of :cidade
  validates_presence_of :estado
  validates_presence_of :cep
  validates_presence_of :telefone
  
  
  validates :estado,        :presence   => true,
                            :length     => { :maximum => 2 , :minimum => 2 }
                            
          
  def self.create_by_params user_id, params
     self.create( :user_id => user_id,
                  :name => params[:name],
                  :card_flag_id => nil,
                  :secure_code => nil,
                  :logradouro => params[:logradouro],
                  :numero => params[:numero],
                  :complemento => params[:complemento],
                  :bairro => params[:bairro],
                  :cidade => params[:cidade],
                  :estado => params[:estado],
                  :cep => params[:cep],
                  :telefone => params[:telefone],
                  :key => nil,
                  :cpf => params[:Identidade],
                  :birthdate => params[:DataNascimento]
                )
  end        
  
  def has_key?
    return self.save_card && !self.key.nil?
  end          
end
