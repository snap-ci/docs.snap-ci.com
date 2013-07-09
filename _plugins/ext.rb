require "compass"
require "jekyll_asset_pipeline"

module JekyllAssetPipeline
  class CompassConverter < JekyllAssetPipeline::Converter
    require 'compass'
    require 'tempfile'

    def self.filetype
      '.scss'
    end

    def initialize(asset)
      @asset = asset
      super
    end

    def convert
      output = Tempfile.new('compass_output')
      Compass.add_project_configuration({})
      Compass.configure_sass_plugin!
      Compass.configuration.add_import_path Pathname.new("./_assets/stylesheets").realpath
      Compass.configuration.add_import_path Pathname.new("./assets/fonts").realpath
      Compass.configuration.add_import_path Pathname.new("./assets/images").realpath
      Compass.compiler.compile("./_assets/stylesheets/#{@asset.filename}", output.path)
      output.read
    end
  end
end