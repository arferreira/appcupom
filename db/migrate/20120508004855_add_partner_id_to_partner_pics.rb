class AddPartnerIdToPartnerPics < ActiveRecord::Migration
  def change
    add_column :partner_pics, :partner_id, :integer
    add_index :partner_pics, :partner_id
  end
end
