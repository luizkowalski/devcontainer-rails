class PagesController < ApplicationController
  def index
    # 首页方法，用于显示最近访问过的话题
    @recent_topics = session[:recent_topics] || []
  end

  def search
    @query = params[:query]
    topic = Topic.find_by(name: @query)
    @posts = topic.present? ? topic.posts.order(posted_at: :desc) : []
  end
end
