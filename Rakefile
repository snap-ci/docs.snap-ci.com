#!/usr/bin/env rake -f

require 'yaml'


def approx_version_string(str)
  Gem::Version.new(str).segments.first(3).join('.')
end

desc "detect versions"
task :detect_versions do
  unless File.exist?('/etc/centos-release')
    $stderr.puts("Not performing any version detection because we are not running on centos.")
    next
  end

  config = YAML.load_file('_config.yml')

  versions = {
    'arch'   => %x[uname -m].strip,
    'centos' => File.read('/etc/centos-release').match(/release ([\d\.]+)/)[1],
    'kernel' => %x[uname -r].strip,
    'ant'    => %x[ant -version].match(/version (.*) compiled/)[1],
    'maven'  => %x[mvn --version].match(/Apache Maven (.*) \(/)[1],
    'gradle' => %x[gradle --version].match(/^Gradle (.*)$/)[1],
    'awscli' => %x[/opt/local/awscli/bin/aws --version 2>&1].match(/^aws-cli\/(\S+)/)[1],
    'git'    => %x[git --version 2>&1].match(/^git version (.*)/)[1]
  }

  development_tools = %w(gcc gcc-c++ make)
  development_libs  = %w(openssl libxml2 libxslt ImageMagick qt5-qtbase)
  sql_sdatabases    = %w(mysql postgresql92 sqlite)
  third_party_tools = %w(heroku-toolbelt s3cmd)
  no_sql_databases  = %w(couchdb redis mongo-10gen)
  languages         = %w()
  browser_tools     = %w(phantomjs google-chrome-stable google-chrome-driver firefox)

  rpms = development_tools + development_libs + sql_sdatabases + no_sql_databases + languages + third_party_tools + browser_tools

  gems = %w(rake bundler foreman)
  python_pips = %w(pip virtualenv)

  exclude_packages = [
    'gpg-pubkey'
  ]

  packages_term_output = %x[rpm -qa --queryformat '%{NAME} %{VERSION}|'].split("|").sort_by {|w| w.downcase}

  filtered_packages = packages_term_output.reject do |package|
    exclude_packages.any? { |p| package.start_with? p }
  end

  packages = filtered_packages.each_slice(3).to_a.inject([]) do |r, packs|
    if packs.size < 3
      r << packs + Array.new(3 - packs.size)
    else
      r << packs
    end
  end

  rpms.each do |pkg|
    versions[pkg] = approx_version_string(%x[rpm -q --queryformat '%{VERSION}' #{pkg}])
    # raise "Could not detect version of package #{pkg}" unless $?.success?
  end

  %w(ruby jruby nodejs php).each do |lang|
    versions[lang] = %x[rpm -q --queryformat '%{NAME} ' $(rpm -qa | egrep "^#{lang}-[0-9]+" | sort)].strip.gsub("#{lang}-", '').split
  end

  versions['python'] = %x[rpm -q --queryformat '%{VERSION} ' $(rpm -qa | egrep '^python-[0-9]+' | sort)].strip.split

  versions['sunjdk'] = Dir['/opt/local/java/*/bin/java'].collect do |java|
    version = %x[#{java} -version 2>&1].match(/java version "(.*)"/)[1]
  end

  python_pips.each do |pip|
    pip_path = Dir['/opt/local/python/*/bin/pip'].first
    version =  %x[#{pip_path} list].lines.grep(%r{^#{pip}\s}).first.chomp
    version =~ /[\S]+ \((.*)\)/
    versions[pip] = $1
  end

  gems.each do |gemname|
    mkdir_p 'tmp'
    gem_spec = %x[unset GEM_HOME GEM_PATH BUNDLE_GEMFILE BUNDLE_BIN_PATH RUBYOPT; gem specification --ruby #{gemname} > tmp/#{gemname}.gemspec]
    spec = Gem::Specification.load("tmp/#{gemname}.gemspec")
    versions[gemname] = spec.version.to_s
  end

  File.open('data/versions.yml', 'w') {|f| f.puts versions.to_yaml }
  File.open('data/packages.yml', 'w') {|f| f.puts packages.to_yaml }
end

desc "build all documentation"
task :build => :detect_versions do
  sh("bundle exec middleman build --verbose --clean")
end

desc "deploy the documentation"
task :deploy do
  sh("bundle exec middleman s3_sync --force --verbose")
  sh("bundle exec middleman s3_redirect")
end
