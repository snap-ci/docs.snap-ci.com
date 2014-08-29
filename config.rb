require File.expand_path('../lib/helpers', __FILE__)
require File.expand_path('../lib/extensions', __FILE__)
require 'active_support/core_ext/numeric/time'

helpers AsArrayHelper
helpers TopicLinkTagHelper
helpers SidebarHelper
helpers ResourcesHelper

Middleman::Extensions.register(:remove_ordering_prefix, RemoveOrderingPrefixExt)

activate :automatic_image_sizes
activate :remove_ordering_prefix
activate :directory_indexes
activate :syntax
activate :asset_hash

configure :development do
  activate :livereload
end

page "/sitemap.xml", :layout => false

ignore 'assets/**/*.txt'
ignore 'assets/**/*.html'

set :url_root, 'http://docs.snap-ci.com'
set :fonts_dir, 'assets/fonts'
set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'
set :partials_dir, 'partials'
set :markdown_engine, :kramdown
set :markdown

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

default_caching_policy max_age: 10.minutes, must_revalidate: true

%w(
  the_ci_environment/index
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
  deployments/rubygems
  working_with_branches/cloned_pipelines
  working_with_branches/integration_pipelines
  working_with_branches/automatic_branch_tracking
  speeding_up_builds/pipeline_parallelism
  speeding_up_builds/cachine
  notifications/campfire_and_hipchat_notifications
  notifications/webhook_notifications
  notifications/cctray_notifications
  managing_your_github_connection/revoking_privileges
  managing_your_github_connection/managing_membership
).each do |old_path|
  new_path = old_path.gsub('_', '-')
  new_path = new_path.gsub(/\/index$/, '') if new_path.end_with?('/index')
  redirect "/#{old_path}/", "/#{new_path}/"
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :relative_assets
end
