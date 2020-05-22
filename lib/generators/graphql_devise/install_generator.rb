module GraphqlDevise
  class InstallGenerator < ::Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    argument :user_class, type: :string, default: 'User'
    argument :mount_path, type: :string, default: 'auth'

    def execute_devise_installer
      generate 'devise:install'
    end

    def execute_dta_installer
      generate 'devise_token_auth:install', "#{user_class} #{mount_path}"
    end

    def mount_resource_route
      routes_file = 'config/routes.rb'
      gem_route   = "mount_graphql_devise_for '#{user_class}', at: '#{mount_path}'"
      dta_route   = "mount_devise_token_auth_for '#{user_class}', at: '#{mount_path}'"

      if file_contains_str?(routes_file, gem_route)
        gsub_file(routes_file, /^\s+#{Regexp.escape(dta_route + "\n")}/i, '') if file_contains_str?(routes_file, dta_route)
        say_status('skipped', "Routes already exist for #{user_class} at #{mount_path}")
      else
        gsub_file(routes_file, /#{Regexp.escape(dta_route)}/i, gem_route)
      end
    end

    private

    def file_contains_str?(filename, regex_str)
      path = File.join(destination_root, filename)

      File.read(path) =~ /(#{Regexp.escape(regex_str)})/i
    end
  end
end
