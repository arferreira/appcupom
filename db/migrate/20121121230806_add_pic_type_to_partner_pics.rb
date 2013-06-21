class AddPicTypeToPartnerPics < ActiveRecord::Migration
  def change
    add_column :partner_pics, :pic_type, :char
  end
end
