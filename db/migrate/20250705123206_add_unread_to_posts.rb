class AddUnreadToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :unread, :boolean, default: false
  end
end
