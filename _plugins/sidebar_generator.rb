require 'pathname'
require 'builder'

module Jekyll
  class SidebarGenerator < Generator
    priority :normal
    OUTPUT_FILENAME = "_includes/sidebar.md"

    def generate(site)
      with_new_sidebar_block do |sidebar|
        emit_new_listing(topic_root, sidebar, site)
      end  
    end
    
    private
    def with_new_sidebar_block(&block)
      File.open(OUTPUT_FILENAME, 'w') do |sidebar_include|
        sidebar = Builder::XmlMarkup.new(:target => sidebar_include, :indent => 2)
        sidebar.div(:class => "sidebar") do |sidebar|
          yield sidebar
        end
      end
    end
    
    def emit_new_listing(topic_folder, sidebar, site)
      sidebar.ul(:class => 'topic-listing') do
        emit_children_listing(topic_folder, sidebar, site)
      end
    end

    def emit_section_element(section_name, sidebar, &block)
      sidebar.li(:class => 'section-name') do
        sidebar << section_name.capitalize
        sidebar.ul { yield }
      end
    end

    def emit_topic_in_current_listing(topic, sidebar, site)
      topic_page = page_at_location(site, topic.to_s)
      sidebar << "{% capture current_page_class %}{% if page.title == '#{topic_page.data['title']}' %}current{% endif %}{% endcapture %}\n"
      sidebar.li(:class => "title {{ current_page_class }}") do
        sidebar.a(topic_page.data['title'], :href => topic_page.url)
      end
    end
    
    def emit_children_listing(topic_folder, sidebar, site)
      emit_section_element(section_name(topic_folder), sidebar) do
        topic_folder.each_child do |f|
          if f.directory?
            emit_new_listing(f, sidebar, site)
          else
            emit_topic_in_current_listing(f, sidebar, site)
          end
        end
      end
    end
    
    def section_name(topic_folder)
      return '' if topic_folder == topic_root
      topic_folder.basename.to_s.gsub(/^\d+\./, '')
    end
    
    def topic_root
      Pathname.new("topics")
    end
    
    def page_at_location(site, path)
      site.pages.detect do |page|
        page_path = page.respond_to?(:topic_path) ? page.topic_path : page.path
        page_path == path
      end
    end
  end
end