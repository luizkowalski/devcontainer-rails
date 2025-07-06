class AddInstagramTimestampToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :instagram_timestamp, :datetime
  end
end
