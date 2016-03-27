class BootboxCrud::InstallGenerator < ::Rails::Generators::Base
  desc 'Copies BootboxCrud default files'
  source_root File.expand_path('../templates', __FILE__)

  def copy_config
    template 'config/initializers/simple_form.rb'
    template 'config/initializers/simple_form_bootstrap.rb'
    template 'app/assets/javascripts/models.js'
  end

  def show_readme
    if behavior == :invoke
      readme 'README'
    end
  end
end
