# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'
#require "capistrano/scm/git"
#install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
# require 'capistrano/rvm'
require 'capistrano/rbenv'
require 'capistrano/nodenv'
# require 'capistrano/chruby'
require 'capistrano/bundler'
#require 'capistrano/rails/assets'
#require 'capistrano/rails/migrations'
# require 'capistrano/passenger'
require 'capistrano3/unicorn'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

require "capistrano/scm/git"

class Capistrano::SCM::Mochimaki < Capistrano::SCM::Git
  def register_hooks
    after "deploy:new_release_path", "mochimaki:create_release"
    before "deploy:check", "git:check"
    before "deploy:set_current_revision", "git:set_current_revision"
  end
end

install_plugin Capistrano::SCM::Mochimaki
