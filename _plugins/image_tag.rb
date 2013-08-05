require 'strscan'

class ImageTube < Liquid::Tag
  IMG_SRC_SCAN_PATTERN = /\s*([^\s]+)\s(.*)$/
  #tokens such as 
  ## foo:bar
  ## foo:'bar baz'
  ## foo:'bar'
  #seprated by spaces
  OPTS_SCAN_PATTERN = /\s*(\w+):((\w+)|('[^']+'))/
  QUOTED_STRING_PATTERN = /^'(.*)'$/

  def initialize(tagName, markup, tokens)
    super
    @src, @opts = parse_src_and_opts(markup)
  end

  def render(context)
<<-IMAGE_TAG
<div class="captioned-image #{@opts['caption_placement']}">
  <img src="#{@src}" alt="#{@opts['alt']}" title="#{@opts['title']}">
  </img>
  <div class="caption">
    #{@opts['caption']}
  </div>
</div>
IMAGE_TAG
  end

  Liquid::Template.register_tag "img", self
  
  private
  def parse_src_and_opts(markup)
    markup =~ IMG_SRC_SCAN_PATTERN
    [unquote($1), parse_options($2)]
  end
  
  def parse_options(opts_string)
    collect_options_into(StringScanner.new(opts_string.strip), {})
  end

  def collect_options_into(scanner, existing_options)
    return existing_options if scanner.eos?
    collect_options_into(scanner, existing_options.merge(parse_option(scanner)))
  end

  def parse_option(scanner)
    key, value = scanner.scan(OPTS_SCAN_PATTERN).split(":").map(&:strip)
    {key => unquote(value)}
  end
  
  def unquote(possibly_quoted_string)
    possibly_quoted_string =~ QUOTED_STRING_PATTERN ? possibly_quoted_string[1..-2] : possibly_quoted_string
  end
end