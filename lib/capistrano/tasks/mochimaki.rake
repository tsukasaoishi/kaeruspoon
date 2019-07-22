def get_mochimaki_pull_url(current_revision)
  system("git fetch")
  commit_id = `git log -1 origin/master --format=%H`.strip
  s3_url = "s3://tsuka-deploy/kaeruspoon/#{commit_id}.tgz"
  puts "aws s3 ls #{s3_url}"
  system("aws s3 ls #{s3_url}", exception: true)
  `aws s3 presign #{s3_url} --expires-in 60`.strip
end

namespace :mochimaki do
  task :get_pull_url do
    run_locally do
      set :mochimaki_pull_url, get_mochimaki_pull_url(fetch(:current_revision))
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
