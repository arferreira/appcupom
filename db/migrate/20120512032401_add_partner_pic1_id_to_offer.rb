class AddPartnerPic1IdToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :partner_pic1_id, :integer

    add_column :offers, :partner_pic2_id, :integer

    add_column :offers, :partner_pic3_id, :integer

  end
end
