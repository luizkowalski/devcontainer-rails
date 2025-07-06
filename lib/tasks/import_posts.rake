# lib/tasks/import_posts.rake
namespace :import do
  desc "Import posts from JSON file"
  task posts: :environment do
    require "json"

    file_path = Rails.root.join("lib", "tasks", "data", "instagram_cat_posts.json")

    unless File.exist?(file_path)
      puts "❌ JSON 文件未找到: #{file_path}"
      exit
    end

    json = JSON.parse(File.read(file_path))

    puts "📥 读取 #{json.size} 条帖子..."

    json.each_with_index do |item, index|
      begin
        topic = Topic.find_or_create_by!(name: item["topic"])

        Post.create!(
          image_url: item["image_url"],
          caption: item["caption"],
          username: item["username"],
          instagram_timestamp: item["timestamp"],
          topic_id: topic.id
        )

        puts "✅ 已导入 ##{index + 1}: #{item["caption"]&.truncate(30)}"
      rescue => e
        puts "⚠️ 跳过第 #{index + 1} 条: #{e.message}"
      end
    end

    puts "✅ 全部导入完成"
  end
end
