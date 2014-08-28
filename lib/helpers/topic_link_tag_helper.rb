module TopicLinkTagHelper
  def topic_link(topic, text)
    topics = html_resources.find_all do |r|
      r.data.title.downcase == topic.downcase
    end
    if topics.length != 1
      raise "Expected 1 topic to match #{topic}, found #{topics.length} instead."
    end
    link_to text, topics.first
  end
end
