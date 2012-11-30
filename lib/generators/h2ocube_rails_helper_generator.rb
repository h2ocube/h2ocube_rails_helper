class H2ocubeRailsHelperGenerator < Rails::Generators::Base
  source_root File.expand_path('../source', __FILE__)

  desc 'Creates a helper.yml to your config/.'

  def copy_helper_yml
    template 'helper.yml.erb', 'config/helper.yml'
  end
  
  def copy_helper_rb
    template 'helper_settings.rb.erb', 'app/models/helper_settings.rb'
  end
  
  private
  
  def app_name
    Rails.application.class.to_s.split('::').first
  end
end
