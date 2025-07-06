# lib/tasks/fetch_posts.rake
namespace :instagram do
  desc "Fetch Instagram posts from API and store in DB"
  task fetch: :environment do
    require Rails.root.join("app/services/instagram_fetcher")

    tags = [ "queen" ]

    tags.each do |tag|
      posts = InstagramFetcher.fetch(tag)
      next unless posts

      posts.each do |data|
        Post.find_or_create_by(image_url: data["image_url"]) do |p|
          p.caption = data["caption"]
          p.username = data["username"]
          p.timestamp = data["timestamp"]
          p.tag = tag
        end
      end
    end

    puts "✅ 所有话题处理完成"
  end
end
