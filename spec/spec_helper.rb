ENV["RAILS_ENV"] ||= 'test'

if ENV['WITH_SIMPLE_COV']
  require 'simplecov'
  SimpleCov.start 'rails'
end

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'email_spec'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Delayed::Worker.delay_jobs = false

RSpec.configure do |config|
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
  config.include(FactoryGirl::Syntax::Methods)

  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false

  config.order = 'random'
  config.render_views = true

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
    ActionMailer::Base.deliveries.clear
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
