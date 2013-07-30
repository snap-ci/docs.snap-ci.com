#!/usr/bin/env rake -f

require 'yaml'

desc "detect versions"
task :detect_versions do

  unless File.exist?('/etc/centos-release')
    $stderr.puts("Not performing any version detection because we are not running on centos.")
    next
  end

  config = YAML.load_file('_config.yml')

  versions = {
    'arch' => %x[uname -m].strip,
    'centos' => File.read('/etc/centos-release').match(/release ([\d\.]+)/)[1]
  }

  rpms = %w(git gcc gcc-c++ make openssl libxml2 libxslt ImageMagick qt48-qt mysql postgresql91 sqlite heroku-toolbelt nodejs phantomjs google-chrome-stable firefox)
  gems = %w(rake bundler)

  rpms.each do |pkg|
    versions[pkg] = %x[rpm -q --queryformat '%{VERSION}' #{pkg}]
    # raise "Could not detect version of package #{pkg}" unless $?.success?
  end

  versions['ruby'] = %x[rpm -q --queryformat '%{NAME} ' $(rpm -qa | egrep 'ruby-[0-9]+' | sort)].strip.gsub('ruby-', '')

  versions['openjdk'] = Dir['/usr/lib/jvm/java-*-openjdk.x86_64/bin/java'].collect do |java|
    version = %x[#{java} -version 2>&1].match(/java version "(.*)"/)[1]
  end

  versions['sunjdk'] = Dir['/usr/lib/jvm/java-*-openjdk.x86_64/bin/java'].collect do |java|
    version = %x[#{java} -version 2>&1].match(/java version "(.*)"/)[1]
  end

  gems.each do |gem|
    mkdir_p 'tmp'
    gem_spec = %x[unset GEM_HOME GEM_PATH BUNDLE_GEMFILE BUNDLE_BIN_PATH RUBYOPT; gem specification --ruby #{gem} > tmp/#{gem}.gemspec]
    spec = Gem::Specification.load("tmp/#{gem}.gemspec")
    versions[gem] = spec.version.to_s
  end

  config['versions'] = versions

  File.open("_config_with_version.yaml", 'w') {|f| f.puts config.to_yaml}

  # ant maven gradle
end

desc "build all documentation"
task :build => :detect_versions do
  sh("bundle exec jekyll build --config _config_with_version.yaml")
end
