class TopicLink < Liquid::Tag
  SYNTAX = /^(\w+)$/

  def initialize(tagName, markup, tokens)
    super
    
    raise "Invalid syntax: #{markup}" unless markup.strip =~ SYNTAX
    @topic_name = "#{$1}.markdown"
    raise "No such file #{@topic_name} in the topics folder" unless topic_file.exist?
  end

  def topic_file
    Pathname.new('.').join('topics', "#{@topic_name}")
  end

  def topic_page(context)
    context.environments.first['site']['pages'].detect {|page| page.name == @topic_name}
  end

  def render(context)
    "<a href='#{topic_page(context).url}' class='topic-link'>#{topic_page(context).basename}</a>"
  end

  Liquid::Template.register_tag "topic_link", self
end