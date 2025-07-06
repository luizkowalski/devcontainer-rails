# app/services/instagram_fetcher.rb

require "uri"
require "net/http"
require "json"

class InstagramFetcher
  API_HOST = "instagram-looter2.p.rapidapi.com"
  API_KEY = ENV.fetch("RAPIDAPI_KEY", "d5ef4466b4msh090f8f80545854ep19e958jsn11c386005166")

  def initialize(tag)
    @tag = tag
  end
  def fetch_and_save_posts
    return [] if @tag.blank?

    posts = fetch_posts_from_api
    return [] unless posts.present?

    saved = []
    posts.each_with_index do |data, index|
      begin
        next if data[:image_url].blank?

        topic = Topic.find_or_create_by!(name: @tag)

        post = Post.create!(
          image_url: data[:image_url].to_s,
          caption: data[:caption].to_s,
          username: data[:username].presence || "unknown_user",
          posted_at: data[:timestamp] || Time.current,
          unread: true,
          topic_id: topic.id
        )

        saved << post
      rescue => e
        Rails.logger.warn("⚠️ 跳过第#{index + 1}条 (image_url=#{data[:image_url]}): #{e.class} - #{e.message}")
      end
    end

    saved
  end


  def fetch_posts_from_api
    url = URI("https://#{API_HOST}/tag-feeds?query=#{@tag}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = API_KEY
    request["x-rapidapi-host"] = API_HOST

    response = http.request(request)
    return [] unless response.code == "200"

    parsed = JSON.parse(response.body)
    edges = parsed.dig("data", "hashtag", "edge_hashtag_to_media", "edges") || []

    edges.map do |edge|
      node = edge["node"]
      {
        image_url: node["display_url"],
        caption: node.dig("edge_media_to_caption", "edges", 0, "node", "text"),
        username: node.dig("owner", "id"),
        timestamp: Time.at(node["taken_at_timestamp"]).utc
      }
    end
  rescue => e
    Rails.logger.error("Instagram fetch failed: #{e.message}")
    []
  end
end
