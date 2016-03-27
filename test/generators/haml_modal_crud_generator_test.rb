require 'test_helper'

require 'generators/rails/haml_modal_crud/haml_modal_crud_generator'

class HamlModalCrudGeneratorTest < GeneratorTestBase
  tests Rails::HamlModalCrudGenerator

  test 'Assert generator creates Block view partials for modals' do
    run_generator %w(Block name width:integer height:integer depth:integer)
    partial_file_content = /model: @block, form_path: 'blocks\/form'/
    assert_file 'app/views/blocks/create.js.erb', partial_file_content
    assert_file 'app/views/blocks/update.js.erb', partial_file_content
    assert_file 'app/views/blocks/destroy.js.erb', partial_file_content
  end
end
