class CreateRecProductComments < ActiveRecord::Migration
  def change
    create_table :rec_product_comments do |t|
      t.references :user
      t.references :recommend_product
      t.text :opinion

      t.timestamps
    end
    add_index :rec_product_comments, :user_id
    add_index :rec_product_comments, :recommend_product_id
  end
end
