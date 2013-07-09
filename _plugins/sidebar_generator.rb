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

    def emit_section_element(section_name, sidebar, &block)
      sidebar.li(:class => 'section-name') do
        sidebar << section_name.to_s.capitalize
        sidebar.ul { yield }
      end
    end

    def generate_child_listing(topic_folder, sidebar, site)
      section_name = (topic_folder == topic_root) ? 'Home' : topic_folder.basename
      emit_section_element(section_name, sidebar) do
        files, directories = partition_children_into_files_and_directories(topic_folder)
        files.each {|f| emit_topic_in_current_listing(f, sidebar, site)}
        directories.each {|f| emit_new_listing(f, sidebar, site)}
      end
    end
    
    def partition_children_into_files_and_directories(folder)
      files, directories = [], []
      folder.each_child { |f| f.directory? ? directories << f : files << f }
      return files, directories
    end
    
    def generate(site)
      with_new_sidebar_block do |sidebar|
        emit_new_listing(topic_root, sidebar, site)
      end  
    end
    
    private
    def topic_root
      Pathname.new("topics")
    end
    
    def page_at_location(site, path)
      site.pages.detect { |page| page.path == path }
    end
  end
end