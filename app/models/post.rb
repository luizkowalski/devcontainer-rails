class Post < ApplicationRecord
  before_save :extract_hashtag
  validates :instagram_id, presence: true, uniqueness: true
  def extract_hashtag
    return unless caption.present?
    self.hashtag = extract_hashtags_from_caption(caption).join(",")
  end

  def extract_hashtags_from_caption(text)
    text.scan(/#\w+/).map { |t| t.delete("#") }
  end
end
