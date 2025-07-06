class AddHashtagToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :hashtag, :string
  end
end
