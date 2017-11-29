source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.1.4'
gem 'mysql2', '>= 0.3.18', '< 0.5'
gem 'webpacker'
gem 'jbuilder', '~> 2.5'

gem 'unicorn'
gem "paperclip"
gem 'aws-sdk', '~> 2.3.0'
gem 'amazon-ecs'
gem "dalli"
gem "word_scoop"
gem 'slim'
gem 'sprockets'
gem 'kaminari'
gem 'wikipedia-client'
gem 'ebisu_connection'
gem 'redcarpet'
gem "pygments.rb"
gem "nokogiri"
gem "bitzer_store"
gem 'sitemap_generator'
gem 'bcrypt'

group :development, :test do
  gem 'byebug'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-ndenv'
  gem 'capistrano-bundler'
  gem 'capistrano3-unicorn'
end

gem 'whenever', require: false
