worker_processes 3
working_directory '/home/rails/kaeru'
listen 9292, :tcp_nopush => true
timeout 30
pid 'tmp/pids/unicorn.pid'
preload_app true
stderr_path 'log/unicorn.log'
stdout_path 'log/unicorn.log'


before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  sleep 1
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection

  Rails.cache.instance_variable_get(:@data).reset if Rails.cache.instance_variable_get(:@data).respond_to?(:reset)
end
