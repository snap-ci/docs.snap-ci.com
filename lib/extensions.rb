%w(
  remove_ordering_prefix_ext
  retina_image_ext
).each do |f|
  require File.join(File.expand_path("../extensions", __FILE__), f)
end
