# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "log/cron.log"
set :environment, :production

every 1.hour do
  runner 'Tasks::ArticleContentAnalyze.run'
end

every 1.day, at: '5:00 am' do
  rake "-s sitemap:refresh"
end
