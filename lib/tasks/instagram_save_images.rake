require "open-uri"

namespace :instagram do
  desc "Fetch posts from Instagram and save images to public folder"
  task fetch_and_save_images: :environment do
    tag = ENV["TAG"] || "cat"
    puts "⚡️ 开始获取话题 ##{tag} 的 Instagram 帖子..."

    posts = InstagramFetcher.new(tag).fetch_and_save_posts

    folder_path = Rails.root.join("public", "post_images")
    FileUtils.mkdir_p(folder_path) unless File.directory?(folder_path)

    posts.each_with_index do |post, idx|
      begin
        timestamp = post.posted_at || Time.current
        filename = "#{tag}_#{timestamp.strftime("%Y%m%d%H%M%S")}_#{idx}.jpg"
        filepath = folder_path.join(filename)

        URI.open(post.image_url.to_s) do |image|
          IO.copy_stream(image, filepath)
        end

        puts "✅ 保存图片: #{filename}"

      rescue => e
        Rails.logger.warn("⚠️ 跳过第#{idx + 1}条: #{e.message}, post: #{post.inspect}")
      end
    end

    puts "🌟 总计已保存 #{posts.size} 条 Post + 图片"
  end
end
