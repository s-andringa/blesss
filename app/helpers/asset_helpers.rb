module AssetHelpers

  def javascript_include_tag(*sources)
    asset_include_tag(sources, "%script{ src: url, type: \"text/javascript\"}")
  end

  def stylesheet_link_tag(*sources)
    asset_include_tag(sources, "%link{ href: url, type: \"text/css\", rel: \"stylesheet\", media: \"screen\"}")
  end

private

  def asset_include_tag(sources, template)
    prefix = "/assets"
    sources.map do |source|
      asset = settings.assets.find_asset(source)
      if settings.debug?
        asset.to_a.map do |a|
          haml template, locals: {url: "#{prefix}/#{a.logical_path}?body=1"}
        end
      else
        haml template, locals: {url: "#{prefix}/#{asset.digest_path}"}
      end
    end.flatten.join
  end
end