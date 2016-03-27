ENV['RAILS_ENV'] = 'test'

require 'rails'
require 'rails/test_help'
require 'rails/generators/base'
require 'rails/generators/test_case'
require 'generators/generator_test_base'

if ActiveSupport.respond_to?(:test_order)
  ActiveSupport.test_order = :random
end
