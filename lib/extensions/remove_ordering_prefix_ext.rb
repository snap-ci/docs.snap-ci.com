class RemoveOrderingPrefixExt < ::Middleman::Extension
  def manipulate_resource_list(resources)
    resources.each do |resource|
      next if resource.content_type !~ %r{text/html}
      resource.destination_path = resource.destination_path.split('/').collect {|component| component.gsub(/^\d+-/, '').gsub('_', '-')}.join('/')
    end
  end
end
