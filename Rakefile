require 'rake'
require 'bundler'
Bundler.require
require 'rake/sprocketstask'
require './assets'

Rake::SprocketsTask.new do |t|
  t.environment = Blesss::Assets
  t.output      = "./public/assets"
  t.assets      = %w( app.js app.css )
end