class AddCompanyNameToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :company_name, :string
  end
end
