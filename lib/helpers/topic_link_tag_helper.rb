module TopicLinkTagHelper
  def topic_link(name, text)
    topic_name, fragment = name.split('#', 2)

    fragment = URI.encode(fragment) if fragment

    topics = all_html_resources.find_all do |r|
      r.data.title.downcase == topic_name.downcase
    end

    if topics.length != 1
      raise "Expected 1 topic to match #{topic_name}, found #{topics.length} instead."
    end

    topic = topics.first

    if topic.data.draft && !current_page.data.draft
      link_to text, topic, :class => 'wip', :fragment => fragment
    else
      link_to text, topic, :fragment => fragment
    end
  end
end
