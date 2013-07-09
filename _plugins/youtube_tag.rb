class YouTube < Liquid::Tag
  Syntax = /^\s*([^\s]+)(\s+(\d+)\s+(\d+)\s*)?/

  def initialize(tagName, markup, tokens)
    super

    if markup =~ Syntax then
      @id = $1
      @width, @height = $2.nil? ? [560, 420] : [$3.to_i, $4.to_i]
    else
      raise "No YouTube ID provided in the \"youtube\" tag"
    end
  end

  def render(context)
    <<-OUTPUT
<div class="youtube-embed">
<iframe width="#{@width}" height="#{@height}" src="http://www.youtube.com/embed/#{@id}?theme=light&amp;autohide=1&amp;modestbranding=1&amp;fs=1&amp;rel=0&amp;showinfo=0&amp;color=white&amp;vq=hd720" frameborder="0">
</iframe>
</div>
    OUTPUT
  end

  Liquid::Template.register_tag "youtube", self
end