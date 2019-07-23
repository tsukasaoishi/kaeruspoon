namespace :mochimaki do
  task :set_current_version do
    run_locally do
      execute :git, "fetch"
      set :current_revision, capture(:git, "log -1 origin/master --format=%H")
    end
  end

  task get_pull_url: 'mochimaki:set_current_version' do
    run_locally do
      s3_url = "s3://tsuka-deploy/kaeruspoon/#{fetch(:current_revision)}.tgz"
      success = execute(:aws, "s3 ls #{s3_url}")
      raise "The tarball(#{s3_url}) is not found" unless success
      set :mochimaki_pull_url, capture(:aws, "s3 presign #{s3_url} --expires-in 60")
    end
  end

  task create_release: 'mochimaki:get_pull_url' do
    on release_roles :all do
      within repo_path do
        execute :mkdir, "-p", release_path
        execute :curl, %Q|-s "#{fetch(:mochimaki_pull_url)}" -o /tmp/deploy.tgz|
        execute "#{SSHKit.config.command_map[:tar]} xfz /tmp/deploy.tgz -C #{release_path}"
      end
    end
  end
end
