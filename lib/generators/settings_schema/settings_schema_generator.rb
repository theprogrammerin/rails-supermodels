class SettingsSchemaGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  VERSION = Time.now.utc.strftime("%Y%m%d%H%M%S")
  def copy_initializer_file

    @module_name = file_name.camelize
    @table_name = "#{file_name}_settings"
    gem 'simple_enum', '1.6.9'
    template "settings.rb.erb", "app/models/#{file_name}/settings.rb"
    template "migration_template.erb", "db/migrate/#{VERSION}_create_#{file_name}_settings.rb"
  end
end
