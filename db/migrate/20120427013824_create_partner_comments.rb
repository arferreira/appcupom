class CreatePartnerComments < ActiveRecord::Migration
  def change
    create_table :partner_comments, :id => false do |t|
      t.references :partner, :null => false
      t.references :user, :null => false
      t.text :comment, :null => false
      t.boolean :approved

      t.timestamps
    end
    add_index :partner_comments, :partner_id
    add_index :partner_comments, :user_id
  end
end
