source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.0.1'
gem 'mysql2', '>= 0.3.18', '< 0.5'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.5'
gem 'bcrypt', '~> 3.1.7'

gem 'unicorn'
gem 'coderay'
gem "paperclip", "~> 4.3.6"
gem 'aws-sdk', '< 2.0'
gem 'amazon-ecs'
gem "js-routes"
gem "dalli"
gem "actionpack-action_caching", github: "rails/actionpack-action_caching"
gem "word_scoop"
gem 'will_paginate', '~> 3.0'
gem 'slim'
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

group :development, :test do
  gem 'byebug'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano3-unicorn'
end

gem 'whenever', :require => false
