require 'pathname'
require 'builder'

module Jekyll
  class SidebarGenerator < Generator
    priority :highest
    OUTPUT_FILENAME = "_includes/sidebar.md"

    def with_new_sidebar_block(&block)
      File.open(OUTPUT_FILENAME, 'w') do |sidebar_include|
        sidebar = Builder::XmlMarkup.new(:target => sidebar_include, :indent => 2)
        sidebar.div(:class => "sidebar") do |sidebar|
          yield sidebar
        end
      end
    end
    
    def emit_topic_in_current_listing(topic, sidebar, site)
      topic_page = page_at_location(site, topic.to_s)
      sidebar << "{% capture current_page_class %}{% if page.title == '#{topic_page.data['title']}' %}current{% endif %}{% endcapture %}\n"
      sidebar.li(:class => "title {{ current_page_class }}") do
        sidebar.a(topic_page.data['title'], :href => topic_page.url)
      end
    end
    
    def emit_new_listing(topic_folder, sidebar, site)
      sidebar.ul(:class => 'topic-listing') do
        generate_child_listing(topic_folder, sidebar, site)
      end
    end

    def generate_child_listing(topic_folder, sidebar, site)
      topic_folder.each_child do |f|
        if f.file?
          emit_topic_in_current_listing(f, sidebar, site)
        elsif f.directory?
          emit_new_listing(f, sidebar, site)
        else
          puts "Skipping entry: #{f}"
        end
      end
    end
    
    def generate(site)
      with_new_sidebar_block do |sidebar|
        emit_new_listing(Pathname.new("topics"), sidebar, site)
      end  
    end
    
    private
    def page_at_location(site, path)
      site.pages.detect { |page| page.path == path }
    end
  end
end