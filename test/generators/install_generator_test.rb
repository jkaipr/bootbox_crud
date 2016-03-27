require 'test_helper'

require 'generators/bootbox_crud/install_generator'

class InstallGeneratorTest < GeneratorTestBase
  tests BootboxCrud::InstallGenerator

  test 'Assert installer copied template files' do
    run_generator
    assert_file 'config/initializers/simple_form.rb'
    assert_file 'config/initializers/simple_form_bootstrap.rb'
    assert_file 'app/assets/javascripts/models.js'
  end
end
