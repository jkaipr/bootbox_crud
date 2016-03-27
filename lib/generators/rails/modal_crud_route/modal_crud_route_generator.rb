class Rails::ModalCrudRouteGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers
  source_root File.expand_path('../templates', __FILE__)

  def add_resource_route
    if Rails.application.assets.find_asset('models.js').blank?
      copy_file 'models.js', 'app/assets/javascripts/models.js'
    end
    inject_into_file 'app/assets/javascripts/models.js', after: "//!!! Generator adds after this line, do not delete it !!!\n" do
      "BBCrud.Models.add('#{name}', '/#{controller_name.underscore}/', '#{name.underscore}');\n"
    end
    run_resource_route
  end

  protected

  def run_resource_route
    generate 'resource_route', name
  end

end
