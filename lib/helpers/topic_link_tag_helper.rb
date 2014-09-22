module TopicLinkTagHelper
  def topic_url(name)
    url_for(topic_with_name(name))
  end

  def topic_link(name, text, opts={})
    topic = topic_with_name(name)
    if topic.data.draft && !current_page.data.draft
      link_to text, topic, :class => opts[:class] || 'wip', :fragment => fragment(name)
    else
      link_to text, topic, :class => opts[:class], :fragment => fragment(name)
    end
  end

  private

  def fragment(name)
    name.split('#', 2)[1]
  end

  def topic_name(name)
    name.split('#', 2)[0]
  end

  def topic_with_name(name)
    fragment = URI.encode(fragment(name)) if fragment(name)

    topics = all_html_resources.find_all do |r|
      r.data.title.downcase == topic_name(name).downcase
    end

    if topics.length != 1
      raise "Expected 1 topic to match #{topic_name(name)}, found #{topics.length} instead."
    end

    topics.first
  end
end
