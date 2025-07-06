# config/schedule.rb (for whenever gem)
every 10.minutes do
  rake "instagram:fetch_popular"
end
