module Jekyll
  module AsArrayFilter
    def as_array(input)
      input || []
    end
  end
end

Liquid::Template.register_filter(Jekyll::AsArrayFilter)