namespace :cache do
  desc 'rails cache clear'
  task :clear => :environment do
    Rails.cache.clear
  end
end
