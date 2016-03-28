ENV['RAILS_ENV'] = 'test'

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require File.expand_path("../../test/dummy/config/environment.rb",  __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)]

#require 'rails'
require 'rails/test_help'
require 'rails/generators/base'
require 'rails/generators/test_case'
require 'generators/generator_test_base'
require 'minitest/rails'

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("#{Rails.root}/test/fixtures")
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
end

if ActiveSupport.respond_to?(:test_order)
  ActiveSupport.test_order = :random
end
