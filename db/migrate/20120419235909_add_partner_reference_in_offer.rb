class AddPartnerReferenceInOffer < ActiveRecord::Migration
  def up
    change_column :offers, :partner_id, :integer, :null => false
    
  end

  def down
  end
end
