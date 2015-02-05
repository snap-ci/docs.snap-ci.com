module AsArrayHelper
  def monospaced_array_to_sentence_string(input)
    as_array(input).collect {|i| "`#{i}`" }.join(', ')
  end

  def monospaced_array_to_bullet_list(input)
    as_array(input).collect {|i| "* `#{i}`" }.join("\n")
  end

  private
  def as_array(input)
    input || []
  end
end
