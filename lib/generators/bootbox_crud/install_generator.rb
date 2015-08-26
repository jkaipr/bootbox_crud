module BootboxCrud
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copies BootboxCrud default files"
      source_root File.expand_path('../templates', __FILE__)

      def copy_config
        template "config/initializers/simple_form.rb"
        template "config/initializers/simple_form_bootstrap.rb"
	    if Rails.application.assets.find_asset('models.js').blank?
	      copy_file "models.js", "app/assets/javascripts/models.js"
	    end
      end

      def show_readme
        if behavior == :invoke
          readme "README"
        end
      end
    end
  end
end
