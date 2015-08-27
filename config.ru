require 'bundler/setup'

require_relative './lib/app'

use Rack::Lint

run App
