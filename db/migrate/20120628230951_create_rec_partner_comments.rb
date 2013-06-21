class CreateRecPartnerComments < ActiveRecord::Migration
  def change
    create_table :rec_partner_comments do |t|
      t.references :recommend_partner
      t.references :user
      t.text :opinion

      t.timestamps
    end
    add_index :rec_partner_comments, :recommend_partner_id
    add_index :rec_partner_comments, :user_id
  end
end
