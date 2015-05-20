# This file is used by Rack-based servers to start the application.
if defined?(Unicorn)
  require 'gctools/oobgc'
  use GC::OOB::UnicornMiddleware
end

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
