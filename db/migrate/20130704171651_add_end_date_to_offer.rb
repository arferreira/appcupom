class AddEndDateToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :end_date, :datetime
  end
end
