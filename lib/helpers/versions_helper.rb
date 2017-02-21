module VersionsHelper
  def versions_of(match)
    data.aurora_versions.keys.find_all {|k| k =~ %r{#{match}}}.collect {|k| "v#{data.aurora_versions[k]}" }.join(', ')
  end
end
