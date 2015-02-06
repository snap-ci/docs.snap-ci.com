require 'open3'

module CommandLineOutputHelper

  def output_of_command(cmd, options={})
    # because `nginx` seems to work well for most CLI output!
    language           = options[:language] || options[:lang] || 'nginx'

    code(language) do
      stdout_and_stderr_of(cmd, options)
    end
  end

  def stdout_and_stderr_of(cmd, options={})
    expected_exit_code = options[:expected_exit_code] || 0

    cmd << " 2>&1" unless cmd =~ /2>&1/
    output = %x[#{cmd}]
    raise "Expected exit status #{expected_exit_code} got #{$?.exitstatus} instead when executing `#{cmd}`" unless $?.exitstatus == expected_exit_code
    output
  end

end
