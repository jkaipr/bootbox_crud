module BootboxCrud
  module Rails
    require "bootstrap_crud/version"
    require "bootstrap_crud/engine"
	require 'bootstrap_crud/action_view/helpers'

	require 'bootstrap_crud/railtie' if defined?(Rails)
  end
end
