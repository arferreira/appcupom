class CreatePartnerPaymentOptions < ActiveRecord::Migration
  def change
    create_table :partner_payment_options, :id => false do |t|
      t.references :partner
      t.references :payment_option

    end
    add_index :partner_payment_options, :partner_id
    add_index :partner_payment_options, :payment_option_id
  end
end
