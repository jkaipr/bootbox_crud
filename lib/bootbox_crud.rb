module BootboxCrud
  module Rails
    require 'bootbox_crud/version'
    require 'bootbox_crud/engine'
    require 'bootbox_crud/action_view/helpers'
    require 'bootbox_crud/railtie' if defined?(Rails)
  end
end
