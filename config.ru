require "rubygems"
require "bundler"
require "base64"

Bundler.require

Sinatra::Request.send :include, Skinny::Helpers

# Get around deprecation warning in Skinny:
module ActiveSupport
  Base64 = ::Base64
end

if development?
  require "sinatra/reloader"
  also_reload "./app/models/person"
  also_reload "./app/helpers/asset_helper"
end

require "./app/models/person"
require "./app/helpers/asset_helpers"
require "./blesss"
require "./assets"

map '/assets' do
  Blesss.set :assets, Blesss::Assets.new(debug: Blesss.debug?)
  run Blesss.assets
end

run Blesss