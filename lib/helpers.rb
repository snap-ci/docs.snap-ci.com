%w(
  as_array_helper
  topic_link_tag_helper
  resources_helper
  sidebar_helper
  command_line_output_helper
  versions_helper
  api_example_rendering_helper
).each do |f|
  require File.join(File.expand_path("../helpers", __FILE__), f)
end
