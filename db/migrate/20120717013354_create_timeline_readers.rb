class CreateTimelineReaders < ActiveRecord::Migration
  def change
    create_table :timeline_readers do |t|
      t.references :user
      t.references :timeline_item

      t.timestamps
    end
    add_index :timeline_readers, :user_id
    add_index :timeline_readers, :timeline_item_id
  end
end
