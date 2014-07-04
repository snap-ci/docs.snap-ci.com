module Jekyll
  module AsArrayFilter
    def as_array(input)
      input || []
    end

    def monospaced_array_to_sentence_string(input)
      array_to_sentence_string(as_array(input).collect {|i| "`#{i}`" })
    end

    def monospaced_array_to_bullet_list(input)
      as_array(input).collect {|i| "* `#{i}`" }.join("\n")
    end
  end
end

Liquid::Template.register_filter(Jekyll::AsArrayFilter)
