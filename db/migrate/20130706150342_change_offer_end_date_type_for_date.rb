class ChangeOfferEndDateTypeForDate < ActiveRecord::Migration
  def change
    change_column :offers, :end_date, :date
  end
end
