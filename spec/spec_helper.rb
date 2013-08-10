ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/poltergeist'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Delayed::Worker.delay_jobs = false

RSpec.configure do |config|

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, inspector: true)
  end

  Capybara.default_driver = :rack_test
  Capybara.javascript_driver = :poltergeist

  config.mock_with :rspec
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.include FactoryGirl::Syntax::Methods

  config.filter_run_excluding empty: true
  config.filter_run :focus

  config.gc_every_n_examples = 5

  Rails.logger.level = 4

  config.before(:each) do
    ActionMailer::Base.deliveries.clear
  end

end

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection