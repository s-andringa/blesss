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

map '/assets' do
  environment = Sprockets::Environment.new
  %w(stylesheets javascripts).each do |dirname|
    environment.append_path File.join(Sinatra::Application.root, "app/assets/#{dirname}")
  end
  environment.css_compressor = YUI::CssCompressor.new
  environment.js_compressor = YUI::JavaScriptCompressor.new(munge: true)
  run environment
end

run Sinatra::Application