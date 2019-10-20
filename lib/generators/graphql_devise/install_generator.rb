module GraphqlDevise
  class InstallGenerator < ::Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    argument :user_class, type: :string, default: 'User'
    argument :mount_path, type: :string, default: 'auth'

    def create_devise_initializer
      generate 'devise:install'
    end

    def execute_dta_installer
      generate 'devise_token_auth:install', "#{user_class} #{mount_path}"
    end

    def mount_resource_route
      routes_file = 'config/routes.rb'
      routes_path = File.join(destination_root, routes_file)
      gem_helper  = 'mount_graphql_devise_for'
      gem_route   = "#{gem_helper} '#{user_class}', at: '#{mount_path}'"
      dta_route   = "mount_devise_token_auth_for '#{user_class}', at: '#{mount_path}'"
      file_start  = 'Rails.application.routes.draw do'

      if File.exist?(routes_path)
        current_route = parse_file_for_line(routes_path, gem_route)

        if current_route.present?
          say_status('skipped', "Routes already exist for #{user_class} at #{mount_path}")
        else
          current_dta_route = parse_file_for_line(routes_path, dta_route)

          if current_dta_route.present?
            replace_line(routes_path, dta_route, gem_route)
          else
            insert_text_after_line(routes_path, file_start, gem_route)
          end
        end
      else
        say_status('skipped', "#{routes_file} not found. Add \"#{gem_route}\" to your routes file.")
      end
    end

    private

    def insert_text_after_line(filename, line, str)
      gsub_file(filename, /(#{Regexp.escape(line)})/mi) do |match|
        "#{match}\n  #{str}"
      end
    end

    def replace_line(filename, old_line, new_line)
      gsub_file(filename, /(#{Regexp.escape(old_line)})/mi, "  #{new_line}")
    end

    def parse_file_for_line(filename, str)
      match = false

      File.open(filename) do |f|
        f.each_line do |line|
          match = line if line =~ /(#{Regexp.escape(str)})/mi
        end
      end
      match
    end
  end
end
