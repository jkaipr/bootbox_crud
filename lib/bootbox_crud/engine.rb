module BootboxCrud
  module Rails
    class Engine < ::Rails::Engine
      require 'bootbox-rails'
      require 'haml-rails'
      require 'simple_form'
      require 'jquery-rails'
      require 'turbolinks'
      require 'jquery-turbolinks'
      require 'remotipart'

      initializer 'bootbox_crud.configure_view' do
        ActiveSupport.on_load :action_view do
          include BootboxCrud::ActionView::Helpers
        end
      end

      config.app_generators do |g|
        g.templates.unshift File::expand_path('../../templates', __FILE__)
      end 
    end
  end
end
