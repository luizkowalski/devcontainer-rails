class AddInstagramIdToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :instagram_id, :string
    add_index :posts, :instagram_id, unique: true
  end
end
