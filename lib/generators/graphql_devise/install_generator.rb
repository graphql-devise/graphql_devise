module GraphqlDevise
  class InstallGenerator < ::Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    argument :user_class, type: :string, default: 'User'
    argument :mount_path, type: :string, default: 'auth'

    def mount_resource_route
      f           = 'config/routes.rb'
      str         = "mount_graphql_devise_for '#{user_class}', at: '#{mount_path}'"
      routes_file = File.join(destination_root, f)

      if File.exist?(routes_file)
        line = parse_file_for_line(f, 'mount_graphql_devise_for')

        if line
          existing_user_class = true
        else
          line = 'Rails.application.routes.draw do'
          existing_user_class = false
        end

        if parse_file_for_line(f, str)
          say_status('skipped', "Routes already exist for #{user_class} at #{mount_path}")
        else
          insert_text_after_line(f, line, str)

          if existing_user_class
            scoped_routes = ''\
              "as :#{user_class.underscore} do\n"\
              "    # Define routes for #{user_class} within this block.\n"\
              "  end\n"
            insert_text_after_line(f, str, scoped_routes)
          end
        end
      else
        say_status('skipped', "config/routes.rb not found. Add \"mount_graphql_devise_for '#{user_class}', at: '#{mount_path}'\" to your routes file.")
      end
    end

    private

    def insert_text_after_line(filename, line, str)
      gsub_file filename, /(#{Regexp.escape(line)})/mi do |match|
        "#{match}\n  #{str}"
      end
    end

    def parse_file_for_line(filename, str)
      match = false

      File.open(File.join(destination_root, filename)) do |f|
        f.each_line do |line|
          match = line if line =~ /(#{Regexp.escape(str)})/mi
        end
      end
      match
    end
  end
end
