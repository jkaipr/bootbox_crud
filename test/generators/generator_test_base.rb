class GeneratorTestBase < Rails::Generators::TestCase
  destination File.expand_path('../../tmp', __FILE__)

  setup do
    prepare_destination
  end
end
