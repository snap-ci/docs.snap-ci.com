<div class="sidebar">
  <ul class="topic-listing">
{% capture current_page_class %}{% if page.title == 'Topic 1' %}current{% endif %}{% endcapture %}
    <li class="title {{ current_page_class }}">
      <a href="/topics/topic1.html">Topic 1</a>
    </li>
{% capture current_page_class %}{% if page.title == 'Topic 2' %}current{% endif %}{% endcapture %}
    <li class="title {{ current_page_class }}">
      <a href="/topics/topic2.html">Topic 2</a>
    </li>
{% capture current_page_class %}{% if page.title == 'Topic 3' %}current{% endif %}{% endcapture %}
    <li class="title {{ current_page_class }}">
      <a href="/topics/topic3.html">Topic 3</a>
    </li>
  </ul>
</div>
