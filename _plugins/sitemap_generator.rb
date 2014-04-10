require 'builder'

module Jekyll
  class SitemapGenerator < Generator
    safe true
    priority :normal
    DAILY_CHANGE_FREQUENCY = 'daily'
    WEEKLY_CHANGE_FREQUENCY = 'weekly'

    NORMAL_PRIORITY = 0.5

    def generate(site)
      with_new_sitemap(site) do |sitemap|
        emit_urlset(sitemap, site)
      end
    end

    private
    def with_new_sitemap(site)
      File.open("#{site.dest}/sitemap.xml", 'w') do |sitemap_file|
        yield Builder::XmlMarkup.new(:target => sitemap_file, :indent => 2)
      end
    end

    def emit_urlset(sitemap, site)
      sitemap.urlset(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9") do |urlset|
        emit_root_url(urlset, site)
        site.pages.each { |page| emit_page_url(urlset, page, site) }
      end
    end

    def emit_root_url(urlset, site)
      emit_new_url(urlset, site.config['url'], DAILY_CHANGE_FREQUENCY)
    end

    def emit_page_url(urlset, post, site)
      emit_new_url(urlset, absolute_url(site, post), WEEKLY_CHANGE_FREQUENCY)
    end

    def emit_new_url(urlset, location, change_frequency)
      urlset.url do |url|
        url.loc location
        url.lastmod simple_date_string(Date.today)
        url.changefreq change_frequency
      end
    end

    def absolute_url(site, page)
      site.config['url'] + page.url
    end

    def simple_date_string(date)
      date.strftime("%Y-%m-%d")
    end
  end
end
