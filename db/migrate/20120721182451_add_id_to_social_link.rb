class AddIdToSocialLink < ActiveRecord::Migration
  def change
    add_column :social_links, :id, :primary_key

  end
end
