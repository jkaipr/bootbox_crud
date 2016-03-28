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

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.fixtures :all
end

if ActiveSupport.respond_to?(:test_order)
  ActiveSupport.test_order = :random
end
