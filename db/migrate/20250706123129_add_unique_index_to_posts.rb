class AddUniqueIndexToPosts < ActiveRecord::Migration[6.1]
  def change
    add_index :posts, [ :image_url, :username ], unique: true
  end
end
