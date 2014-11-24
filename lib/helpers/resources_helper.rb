module ResourcesHelper

  def edit_documentation_url
    p = Pathname(current_page.source_file).relative_path_from(Pathname(root))
    "https://github.com/snap-ci/docs.snap-ci.com/blob/master/#{p}"
  end

  def html_resources
    all_html_resources.find_all { |r| !r.data.draft }
  end

  def all_html_resources
    sitemap.resources.find_all {|r| r.content_type =~ %r{text/html} }
  end
end
