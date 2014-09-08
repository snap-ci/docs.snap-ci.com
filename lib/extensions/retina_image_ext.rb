class RetinaImageExt < ::Middleman::Extension

  def manipulate_resource_list(resources)
    require 'RMagick'

    retina_images = retina_resources(resources)
    resources + retina_images
  end

  def before_build(builder)
    retina_resources(@app.sitemap.resources).each do |res|
      @app.sitemap.resources << res
    end
  end

  helpers do
    def retina_image(image_name)
      retina_image = "retina/#{image_name}@2x.png"
      normal_image = "non-retina/#{image_name}.png"
      image_tag(normal_image, 'data-at2x' => image_path(retina_image))
    end
  end

  private
  def retina_resources(resources)
    images = resources.find_all {|r| r.content_type =~ /^image\//}
    retina_img_resources = images.find_all {|r| r.path =~ /@2x/}

    retina_img_resources.collect do |retina_img_resource|
      NonRetinaImageResource.new(@app.sitemap, retina_img_resource).tap(&:process)
    end
  end

  class NonRetinaImageResource < ::Middleman::Sitemap::Resource
    def initialize(store, retina_img_resource)
      super(store, retina_img_resource.path.gsub('/retina/', '/non-retina/').gsub('@2x', ''), retina_img_resource.source_file.gsub('/retina/', '/non-retina/').gsub('@2x', ''))
      @retina_img_resource = retina_img_resource
    end

    def process
      FileUtils.mkdir_p(File.dirname(source_file))
      if changed?
        @app.logger.info("== Creating non-retina resource #{path}")
        retina_img = Magick::Image::read(@retina_img_resource.source_file).first
        non_retina_img = retina_img.scale(0.5)
        non_retina_img['Original-SHA'] = Digest::SHA1.hexdigest(File.read(@retina_img_resource.source_file))
        non_retina_img.write(source_file)
      end
    end

    def changed?
      return true unless File.exist?(source_file)
      non_retina_img = Magick::Image::read(source_file).first
      non_retina_img['Original-SHA'] != Digest::SHA1.hexdigest(File.read(@retina_img_resource.source_file))
    end

    delegate :binary?, :template?, :metadata, to: :@retina_img_resource
  end
end
