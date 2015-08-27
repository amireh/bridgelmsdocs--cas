require 'bundler/setup'

Bundler.require('default');

require_relative './lib/app'

run Sinatra::Application
