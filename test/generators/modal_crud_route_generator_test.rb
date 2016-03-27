require 'test_helper'
require 'mocha/mini_test'

require 'generators/rails/modal_crud_route/modal_crud_route_generator'

class ModalCrudRouteGeneratorTest < GeneratorTestBase
  # include Mocha::Integration::MiniTest
  tests Rails::ModalCrudRouteGenerator

  test 'Assert generator creates Block view partials for modals' do
    stub_application_assets
    run_generator %w(Block name width:integer height:integer depth:integer)
    partial_file_content = /'Block', '\/blocks\/', 'block'/
    assert_file 'app/assets/javascripts/models.js', partial_file_content
  end

  def stub_application_assets
    assets = mock('assets', :find_asset =>'')
    application = mock('application', :assets => assets)
    Rails.stubs(:application).returns(application)
  end
end
