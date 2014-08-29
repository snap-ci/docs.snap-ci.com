module ResourcesHelper
  def html_resources
    all_html_resources.find_all { |r| !r.data.draft }
  end

  def all_html_resources
    sitemap.resources.find_all {|r| r.content_type =~ %r{text/html} }
  end
end
