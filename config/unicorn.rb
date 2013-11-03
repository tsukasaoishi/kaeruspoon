worker_processes 3
working_directory '/home/rails/kaeru'
listen 9292, :tcp_nopush => true
timeout 30
pid 'tmp/pids/puma.pid'
preload_app true
stderr_path 'log/unicorn.log'
stdout_path 'log/unicorn.log'


before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection
  Rails.cache.instance_variable_get(:@data).reset if Rails.cache.instance_variable_get(:@data).respond_to?(:reset)
end
