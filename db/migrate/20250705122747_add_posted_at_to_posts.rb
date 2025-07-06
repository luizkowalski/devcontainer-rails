class AddPostedAtToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :posted_at, :datetime
  end
end
