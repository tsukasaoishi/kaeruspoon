source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.1.4'
gem 'mysql2', '>= 0.3.18', '< 0.5'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'bcrypt', '~> 3.1.7'

gem 'unicorn'
gem 'coderay'
gem "paperclip"
gem 'aws-sdk', '~> 2.3.0'
gem 'amazon-ecs'
gem "js-routes"
gem "dalli"
gem "word_scoop"
gem 'slim'
gem 'kaminari'
gem 'wikipedia-client'
gem 'ebisu_connection'
gem 'reverse_markdown'
gem 'redcarpet'
gem "pygments.rb"
gem "nokogiri"
gem "active_decorator"
gem "font-awesome-rails"
gem "bitzer_store"
gem "rb-readline"
gem 'google-api-client'
gem 'sitemap_generator'

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
  gem 'capistrano-bundler'
  gem 'capistrano3-unicorn'
end

gem 'whenever', require: false
