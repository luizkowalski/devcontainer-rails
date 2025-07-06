# lib/tasks/instagram_fetcher.rake
namespace :instagram do
  desc "Fetch posts for popular tags"
  task fetch_popular: :environment do
    %w[cat dog nature fashion art].each do |tag|
      puts "Fetching ##{tag}..."
      InstagramFetcher.new(tag).fetch_and_save_posts
    end
  end
end
