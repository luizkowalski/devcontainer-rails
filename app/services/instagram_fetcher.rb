require "net/http"
require "uri"
require "json"

class InstagramFetcher
  API_HOST = "instagram-looter2.p.rapidapi.com"
  API_KEY = ENV.fetch("RAPIDAPI_KEY")

  def initialize(tag)
    @tag = tag
  end

  def fetch_and_save_posts
    posts = fetch_posts_from_api
    saved = []
    posts.each do |data|
      next if data[:image_url].blank?

      post = Post.find_or_create_by!(image_url: data[:image_url]) do |p|
        p.caption = data[:caption]
        p.username = data[:username]
        p.posted_at = data[:timestamp]
        p.unread = true
        p.topic_id = Topic.find_or_create_by!(name: @tag).id
      end
      saved << post
    end
    saved
  end

  private

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
