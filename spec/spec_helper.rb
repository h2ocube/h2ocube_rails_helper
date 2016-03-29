ENV['RAILS_ENV'] = 'test'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rails'
require 'bundler/setup'
Bundler.require

require 'capybara/rspec'
require 'fake_app/rails_app'
require 'rspec/rails'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rr
  config.filter_run_excluding generator_spec: true unless ENV['GENERATOR_SPEC']
  config.raise_errors_for_deprecations!
  config.include H2ocubeRailsHelper::ActionView::Helpers
end
