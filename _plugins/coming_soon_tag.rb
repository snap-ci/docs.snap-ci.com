class ComingSoonTag < Liquid::Tag
  def render(context)
    <<-OUTPUT
<span class="coming-soon">Coming soon</span>
    OUTPUT
  end

  Liquid::Template.register_tag "coming_soon", self
end