require File.expand_path('../lib/helpers', __FILE__)
require File.expand_path('../lib/extensions', __FILE__)
require 'active_support/core_ext/numeric/time'

helpers AsArrayHelper
helpers TopicLinkTagHelper
helpers SidebarHelper
helpers ResourcesHelper
helpers CommandLineOutputHelper
helpers VersionsHelper
helpers ApiExampleRenderingHelper

Middleman::Extensions.register(:remove_ordering_prefix, RemoveOrderingPrefixExt)
Middleman::Extensions.register(:retina_image_ext, RetinaImageExt)

activate :retina_image_ext
activate :automatic_image_sizes
activate :remove_ordering_prefix
activate :directory_indexes
activate :syntax

configure :development do
  activate :livereload
end

page "/sitemap.xml", :layout => false

ignore 'assets/**/*.txt'
ignore 'assets/**/*.html'
ignore 'api-requests/*'
ignore '.idea/*'

set :file_watcher_ignore, [
  %r{api-requests/.*/response.headers.txt},
  %r{api-requests/.*/response.body.json},
  %r{\.idea/.*}
]

set :url_root, 'https://docs.snap-ci.com'
set :fonts_dir, 'assets/fonts'
set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'
set :partials_dir, 'partials'
set :markdown_engine, :kramdown
set :markdown, :auto_ids => false

if ENV['S3_BUCKET']
  activate :s3_redirect do |config|
    config.bucket                = ENV['S3_BUCKET']
    config.region                = 'us-east-1'
    config.aws_access_key_id     = ENV['S3_ACCESS_KEY']
    config.aws_secret_access_key = ENV['S3_SECRET_KEY']
    # don't s3 redirect immediately after build
    config.after_build           = false
  end

  activate :s3_sync do |config|
    config.bucket                = ENV['S3_BUCKET']
    config.region                = 'us-east-1'
    config.aws_access_key_id     = ENV['S3_ACCESS_KEY']
    config.aws_secret_access_key = ENV['S3_SECRET_KEY']
    config.delete                = true
    # don't s3 sync immediately after build
    config.after_build           = false
  end

  if ENV['CLOUDFRONT_DISTRIBUTION']
    activate :cloudfront do |cf|
      cf.access_key_id = ENV['S3_ACCESS_KEY']
      cf.secret_access_key = ENV['S3_SECRET_KEY']
      cf.distribution_id = ENV['CLOUDFRONT_DISTRIBUTION']
      cf.after_build = false  # default is false
    end
  end

  default_caching_policy max_age: 10.minutes, must_revalidate: true

  %w(
    the_ci_environment/index
    the_ci_environment/languages
    the_ci_environment/languages/index
    the_ci_environment/languages/ruby-jruby
    the_ci_environment/languages/python
    the_ci_environment/languages/nodejs
    the_ci_environment/languages/php
    the_ci_environment/languages/java
    the_ci_environment/languages/groovy-gradle
    the_ci_environment/languages/c-c++
    the_ci_environment/languages/android
    the_ci_environment/databases/index
    the_ci_environment/databases/relational
    the_ci_environment/databases/no-sql
    the_ci_environment/testing_with_browsers
    the_ci_environment/complete-package-list
    environment_variables
    deployments/heroku_deployments
    deployments/aws_deployments
    working_with_branches/cloned_pipelines
    working_with_branches/integration_pipelines
    working_with_branches/automatic_branch_tracking
    speeding_up_builds/pipeline_parallelism
    speeding_up_builds/caching
    notifications/campfire_and_hipchat_notifications
    notifications/webhook_notifications
    notifications/cctray_notifications
    managing_your_github_connection/revoking_privileges
    managing_your_github_connection/managing_membership
    api/index
  ).each do |old_path|
    new_path = old_path.gsub('_', '-')
    new_path = new_path.gsub(/\/index$/, '') if new_path.end_with?('/index')
    redirect "/#{old_path}/", "/#{new_path}/"
  end

  {
    '/api/introduction/'                                                          => '/api/',
    '/databases/'                                                                 => '/the-ci-environment/databases/',
    '/pipeline/introduction/'                                                     => '/pipeline/',
    '/pipeline_clones_and_integration_pipelines/cloned_pipelines/'                => '/working-with-branches/cloned-pipelines/',
    '/pipeline_clones_and_integration_pipelines/integration_pipelines/'           => '/working-with-branches/integration-pipelines/',
    '/pipeline_clones_and_integration_pipelines/automatically_tracking_branches/' => '/working-with-branches/automatic-branch-tracking/',
    '/pipeline_clones_and_integration_pipelines/automatic_branch_tracking/'       => '/working-with-branches/automatic-branch-tracking/',
    '/supported_platforms/'                                                       => '/the-ci-environment/',
    '/the_ci_environment/the_ci_environment/'                                     => '/the-ci-environment/',
    '/the_ci_environment/languages/overview/'                                     => '/the-ci-environment/languages/',
    '/deployments/heroku/basic_heroku/'                                           => '/deployments/heroku-deployments/',
    '/deployments/heroku/custom_heroku_stage/'                                    => '/deployments/heroku-deployments/',
    '/notifications/campfire-and-hipchat-notifications'                           => '/notifications/campfire/',
  }.each do |old_path, new_path|
    redirect old_path.dup, new_path.dup
  end

  redirect '/', '/getting-started/'
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
  activate :relative_assets
end
