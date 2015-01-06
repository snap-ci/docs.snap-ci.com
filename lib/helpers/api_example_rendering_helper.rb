require 'fileutils'

module ApiExampleRenderingHelper

  def render_api_example(path, options={})
    path = File.join(current_page.app.source_dir, 'api-requests', path)
    api_render_template = File.join(current_page.app.source_dir, 'api-requests', 'render-api-example.md.erb')

    options.assert_valid_keys(:method, :url, :capture_mode)

    curl_cmd = build_curl_command(options, path)
    maybe_capture_new_response(curl_cmd, options, path)

    response_headers = File.read(File.join(path, 'response.headers.txt')).lines.grep(/(HTTP\/1.1)|(Location|Content-Type):/i)

    response_body = File.read(File.join(path, 'response.body.json'))

    erb = ERB.new(File.read(api_render_template), nil, '-')
    erb.result(binding)
  end

  private

  def build_curl_command(options, path)
    curl_cmd = []
    curl_cmd << 'curl'

    curl_cmd << '-u'
    curl_cmd << 'alice:API_KEY'

    if options[:method]
      curl_cmd << '-X'
      curl_cmd << options[:method].to_s.upcase
    end

    curl_cmd << '-H'
    curl_cmd << "'Accept: #{current_page.app.data.api.current_version}'"

    curl_cmd << options[:url]

    if %w(put post).include?(options[:method].to_s.downcase) && File.exist?(File.join(path, 'request.body.json'))
      curl_cmd << '--data'
      curl_cmd << ("'" << File.read(File.join(path, 'request.body.json')).strip << "'")
    end
    curl_cmd
  end

  def maybe_capture_new_response(curl_cmd, options, path)
    return unless options[:capture_mode]

    raise 'Will not capture during build' if current_page.app.build?

    FileUtils.mkdir_p(path)

    capture_cmd = curl_cmd.dup
    capture_cmd << '--fail'
    capture_cmd << '-u'
    capture_cmd << "#{ENV['API_USER']}:#{ENV['API_KEY']}"
    capture_cmd << '--silent'
    capture_cmd << '--dump-header'
    capture_cmd << File.join(path, 'response.headers.txt')
    capture_cmd << '--output'
    capture_cmd << File.join(path, 'response.body.json')
    cmd = "#{capture_cmd.join(' ')}"

    output = %x[#{cmd}]
    unless $?.exitstatus == 0
      puts "The output contained #{output}"
      raise "Expected exit status 0 got #{$?.exitstatus} instead when executing `#{cmd}`"
    end
  end

end
