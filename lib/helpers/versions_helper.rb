module VersionsHelper
  def versions_of(match)
    data.versions.keys.find_all {|k| k =~ %r{#{match}}}.collect {|k| "v#{data.versions[k]}" }.join(', ')
  end
end
