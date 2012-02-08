require 'rake'
require 'bundler'
Bundler.require
require 'rake/sprocketstask'

require './app/helpers/asset_helpers'
require './blesss'
require './assets'

Rake::SprocketsTask.new do |t|
  t.environment = Blesss::Assets.new(debug: false)
  t.output      = "./public/assets"
  t.assets      = %w( app.js app.css )
end