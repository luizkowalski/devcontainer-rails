class TopicsController < ApplicationController
  def search
    @query = params[:q]
    @posts = Post.where("hashtag ILIKE ?", "%#{@query}%").order(instagram_timestamp: :desc)

    session[:recent_topics] ||= []
    session[:recent_topics].delete(@query)
    session[:recent_topics] << @query
    session[:recent_topics] = session[:recent_topics].last(5)
  end
end
