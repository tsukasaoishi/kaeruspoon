require "capistrano/scm/plugin"

class Capistrano::SCM::Mochimaki < Capistrano::SCM::Plugin
  def register_hooks
    after "deploy:new_release_path", "mochimaki:create_release"
  end
end
