class AddWorkingScheduleToPartner < ActiveRecord::Migration
  def change
    add_column :partners, :working_schedule, :string

  end
end
