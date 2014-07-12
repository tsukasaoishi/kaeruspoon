# This file is used by Rack-based servers to start the application.
require 'unicorn/oob_gc'

use Unicorn::OobGC, 5
use UnicornKiller::Oom
use UnicornKiller::MaxRequests

require ::File.expand_path('../config/environment',  __FILE__)
run Kaeruspoon::Application
