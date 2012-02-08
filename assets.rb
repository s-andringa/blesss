class Blesss::Assets < Sprockets::Environment

  def initialize(options = {})
    super(Blesss.root)
    asset_folders.each do |dirname|
      append_path "app/assets/#{dirname}"
    end
    if options[:debug] == false
      self.css_compressor = YUI::CssCompressor.new
      self.js_compressor  = YUI::JavaScriptCompressor.new(munge: true)
    end
    self.context_class.instance_eval do
      include AssetHelpers
    end
  end

  def asset_folders
    %w(stylesheets javascripts)
  end

end