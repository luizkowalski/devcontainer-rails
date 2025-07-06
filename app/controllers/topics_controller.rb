class TopicsController < ApplicationController
  def search
    @query = params[:q]

    begin
      fetch_and_store_latest_posts(@query)
    rescue => e
      Rails.logger.error("Instagram fetch failed: #{e.message}")
    end

    @posts = Post.where("hashtag ILIKE ?", "%#{@query}%").order(instagram_timestamp: :desc)

    session[:recent_topics] ||= []
    session[:recent_topics].delete(@query)
    session[:recent_topics] << @query
    session[:recent_topics] = session[:recent_topics].last(5)
  end


  def fetch_and_store_latest_posts(tag)
    posts_data = InstagramFetcher.new(tag).fetch_and_save_posts


    posts_data.each do |post_data|
      Post.create_with(
        caption: post_data[:caption],
        image_url: post_data[:image_url],
        username: post_data[:username],
        instagram_timestamp: post_data[:timestamp]|| post_data[:posted_at]
      ).find_or_create_by!(
        image_url: post_data[:image_url],
        username: post_data[:username]
      )
    end
  end


  def fetch_new
    @topic = Topic.find_by(name: params[:q])
    since = Time.at(params[:since].to_i)
    @posts = @topic.posts.where("instagram_timestamp > ?", since).order(instagram_timestamp: :desc)
    Rails.logger.info "[fetch_new] since=#{since}, found=#{@posts.size}"

    render partial: "topics/post_card", collection: @posts, as: :post
  end
end
