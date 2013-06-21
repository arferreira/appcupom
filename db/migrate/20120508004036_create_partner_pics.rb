class CreatePartnerPics < ActiveRecord::Migration
  def change
    create_table :partner_pics do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
