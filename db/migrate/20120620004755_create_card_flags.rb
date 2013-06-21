class CreateCardFlags < ActiveRecord::Migration
  def change
    create_table :card_flags do |t|
      t.string :flag

      t.timestamps
    end
  end
end
