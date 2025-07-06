class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :topic, null: false, foreign_key: true
      t.string :image_url
      t.text :caption
      t.string :username

      t.timestamps
    end
  end
end
