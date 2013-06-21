class AddPasswordResetToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :password_reset_token, :string

    add_column :partners, :password_reset_sent_at, :datetime

  end
end
