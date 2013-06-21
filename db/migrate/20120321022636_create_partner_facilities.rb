class CreatePartnerFacilities < ActiveRecord::Migration
  def change
    create_table :partner_facilities, :id => false do |t|
      t.references :partner, :null => false
      t.references :facility, :null => false

      t.timestamps
    end
    add_index :partner_facilities, :partner_id
    add_index :partner_facilities, :facility_id
  end
end
