class TopicLink < Liquid::Tag
  SYNTAX = /^([\w\s]+)$/

  def initialize(tagName, markup, tokens)
    super
    
    raise "Invalid syntax: #{markup}" unless markup.strip =~ SYNTAX
    @topic_name = $1
  end

  def topic_page(context)
    context.environments.first['site']['pages'].detect {|page| page.data['title'] == @topic_name}
  end

  def render(context)
    raise "No such file with topic title #{@topic_name} in the topics folder" unless topic_page(context)
    
    "<a href='#{topic_page(context).url}' class='topic-link'>#{topic_page(context).data['title']}</a>"
  end

  Liquid::Template.register_tag "topic_link", self
end