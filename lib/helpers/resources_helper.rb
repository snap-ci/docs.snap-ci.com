module ResourcesHelper
  def html_resources
    sitemap.resources.find_all {|r| r.content_type =~ %r{text/html} }
  end
end
