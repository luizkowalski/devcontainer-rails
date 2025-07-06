class PagesController < ApplicationController
  def index
    @recent_topics = session[:recent_topics] || []
  end

  def search
    @query = params[:query]
    topic = Topic.find_by(name: @query)
    @posts = topic.present? ? topic.posts.order(posted_at: :desc) : []
  end
end
