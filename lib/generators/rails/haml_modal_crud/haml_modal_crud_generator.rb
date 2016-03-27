require 'rails/generators/erb'
require 'rails/generators/resource_helpers'

class Rails::HamlModalCrudGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers
  argument :attributes, type: :array, default: [], banner: 'field:type field:type'
  source_root File.expand_path('../templates', __FILE__)

  def copy_view_files
    available_actions.each do |view|
      template "#{view}.js.erb", File.join('app/views', controller_file_path, "#{view}.js.erb")
    end
    run_haml
  end

  protected

  def available_actions
    %w(create update destroy)
  end

  def handler
    :erb
  end

  def run_haml
    attrs = attributes.collect {|a| "#{a.name}:#{a.type}" }
    generate 'haml:scaffold', name, *attrs
  end
end
