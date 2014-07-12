# This file is used by Rack-based servers to start the application.
if true#defined?(Unicorn) && ENV['RACK_ENV'] == "production"
  require 'unicorn/oob_gc'
  use Unicorn::OobGC, 5

  require 'unicorn/worker_killer'
  use Unicorn::WorkerKiller::MaxRequests
  use Unicorn::WorkerKiller::Oom
end

require ::File.expand_path('../config/environment',  __FILE__)
run Kaeruspoon::Application
