require 'pathname'
require 'builder'

module Jekyll
  class SidebarGenerator < Generator
    priority :normal
    OUTPUT_FILENAME = "_includes/sidebar.md"

    def generate(site)
      with_new_sidebar_block do |sidebar|
        DirNode.new(Pathname.new('topics'), Pathname.new('topics')).to_html(sidebar, site)
      end
    end

    private
    def with_new_sidebar_block(&block)
      buffer = StringIO.new
      sidebar = Builder::XmlMarkup.new(:target => buffer, :indent => 2)
      sidebar.div(:class => "sidebar") do |sidebar|
        yield sidebar
      end

      unless File.exist?(OUTPUT_FILENAME) && File.read(OUTPUT_FILENAME) == buffer.string
        # do not tailspin if nothing has changed
        File.open(OUTPUT_FILENAME, 'w') do |f|
          f.puts(buffer.string)
        end
      end
    end


    class Node
      def initialize(path)
        @path = path
      end

      def page_at_location(site, path)
        site.pages.detect do |page|
          page_path = page.respond_to?(:topic_path) ? page.topic_path : page.path
          page_path == path
        end
      end
    end

    class LeafNode < Node
      def to_html(html, site)
        topic_page = page_at_location(site, @path.to_s)
        html.li(:class => "title {% if page.url == '#{topic_page.url}' %}current{% endif %}") do
          html.a(topic_page.data['title'], :href => topic_page.url)
        end
      end
    end

    class DirNode < Node

      attr_reader :topic_root

      def initialize(path, topic_root)
        super(path)
        @topic_root = topic_root
      end

      def index_page(site)
        index_page_path = @path.children.detect do |child|
          page = page_at_location(site, child.to_s)
          page && File.basename(page.url) == 'index'
        end
      end

      def to_html(html, site)
        html.ul(:class => 'topic-listing') do
          html.li(:class => 'section-name') do
            html.ul do
              section_name(html, site)

              @path.children.each do |child|
                if child.directory?
                  DirNode.new(child, topic_root).to_html(html, site)
                elsif child == index_page(site)
                  next
                else
                  LeafNode.new(child).to_html(html, site)
                end
              end
            end
          end

        end
      end

      def section_name(html, site)
        if @path == topic_root
          topic_page = page_at_location(site, 'index.html')
          html.li(:class => "title {% if page.url == '#{topic_page.url}' %}current{% endif %}") do
            html.a('Home', :href => "/")
          end
        elsif child = index_page(site)
          index_page = page_at_location(site, child.to_s)
          html.li(:class => "title {% if page.url == '#{index_page.url}' %}current{% endif %}") do
            html.a(index_page.data['title'], :href => index_page.url)
          end
        else
          html.span @path.basename.to_s.gsub(/^\d+\./, '').gsub('_', ' ').capitalize
        end
      end
    end

  end
end
