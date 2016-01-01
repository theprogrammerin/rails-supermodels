require 'test_helper'
require 'generators/settings_schema/settings_schema_generator'

class SettingsSchemaGeneratorTest < Rails::Generators::TestCase
  tests SettingsSchemaGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
