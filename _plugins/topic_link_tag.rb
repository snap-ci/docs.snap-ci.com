class TopicLink < Liquid::Tag
  SYNTAX = /^((\w+)|('[^']*')|("[^"]*"))(\s+(.*))?$/
  QUOTED_STRING_PATTERN = /^('(.*)')|("[^"]*")$/

  def initialize(tagName, markup, tokens)
    super

    raise "Invalid syntax: #{markup}" unless markup.strip =~ SYNTAX
    @topic_name, @link_text = unquote($1.strip), unquote(($5 || '').strip)
  end

  def topic_page(context)
    context.environments.first['site']['pages'].detect {|page| (page.data['title'] || '').downcase == @topic_name.downcase}
  end

  def link_text(context)
    @link_text || topic_page(context).data['title']
  end

  def link_href(context)
    topic_page(context).url
  end

  def render(context)
    raise "No such file with topic title #{@topic_name} in the topics folder" unless topic_page(context)
    "<a href='#{link_href(context)}' class='topic-link'>#{link_text(context)}</a>"
  end

  def unquote(possibly_quoted_string)
    return nil unless possibly_quoted_string
    possibly_quoted_string =~ QUOTED_STRING_PATTERN ? possibly_quoted_string[1..-2] : possibly_quoted_string
  end

  Liquid::Template.register_tag "topic_link", self
end
