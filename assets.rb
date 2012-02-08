module Blesss
  Assets = Sprockets::Environment.new(Sinatra::Application.root) do |env|
    %w(stylesheets javascripts).each do |dirname|
      env.append_path "app/assets/#{dirname}"
    end
    env.css_compressor = YUI::CssCompressor.new
    env.js_compressor = YUI::JavaScriptCompressor.new(munge: true)
  end
end