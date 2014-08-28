xml.instruct!
xml.urlset 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  sitemap.resources.find_all {|r| r.content_type =~ %r{text/html} }.each do |page|
    xml.url do
      xml.loc File.join(url_root, page.url)
      xml.lastmod File.mtime(page.source_file).iso8601
      xml.changefreq 'weekly'
      xml.priority (if page.url == "/" or page.url == "/index.html"
        1.0
      else
        1.0 - nesting_of(page)/10.0
      end)
    end
  end
end
