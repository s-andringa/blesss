require "rubygems"
require "bundler"
require "base64"

Bundler.require

Sinatra::Request.send :include, Skinny::Helpers

# Get around deprecation warning in Skinny:
module ActiveSupport
  Base64 = ::Base64
end

require "sinatra/reloader" if development?
also_reload "./app/models/person"

require "./app/models/person"
require "./blesss"
require "./assets"

map '/assets' do
  run Blesss::Assets
end

run Sinatra::Application