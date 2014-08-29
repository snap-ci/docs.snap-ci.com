module TopicLinkTagHelper
  def topic_link(topic_name, text)
    topics = all_html_resources.find_all do |r|
      r.data.title.downcase == topic_name.downcase
    end
    if topics.length != 1
      raise "Expected 1 topic to match #{topic_name}, found #{topics.length} instead."
    end

    topic = topics.first

    if topic.data.draft && !current_page.data.draft
      link_to text, topic, :class => 'wip'
    else
      link_to text, topic
    end
  end
end
