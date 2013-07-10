require 'pathname'

module Jekyll

  class DocumentationTopic < Page
    LEADING_ORDERING_FRAGMENT = /^(\d+\.)/
    
    def topic_path
      (Pathname.new('topics') + path).to_s
    end
    
    def url
      super.split('/').map{ |s| strip_leading_sort_ordering_fragment(s) }.join('/').gsub('//', '/')
    end
    
    private
    def strip_leading_sort_ordering_fragment(path_fragment)
      path_fragment.gsub(LEADING_ORDERING_FRAGMENT, '')
    end
  end

  class TopicGenerator < Generator
    priority :highest
    
    def generate(site)
      generate_topic_section(topic_root, site)
    end
    
    private
    def topic_root
      Pathname.new("topics")
    end
    
    def generate_topic_section(file, site)
      file.each_child do |f|
        if f.file?
          generate_topic(f, site)
        else
          generate_topic_section(f, site)
        end
      end
    end
    
    def generate_topic(file, site)
      remove_existing_default_page(file, site)
      add_documentation_topic(file, site)
    end

    def basename(file)
      file.to_s.gsub('topics/', '')
    end
    
    def add_documentation_topic(file, site)
      site.pages << Jekyll::DocumentationTopic.new(site, 'topics', "/", basename(file))
    end
    
    def remove_existing_default_page(file, site)
      site.pages.delete_if { |page| page.path == file.to_s }
    end
  end
end