# frozen_string_literal: true

module GraphqlDevise
  class InstallGenerator < ::Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    argument :user_class, type: :string, default: 'User'
    argument :mount_path, type: :string, default: 'graphql_auth'

    class_option :mount, type: :string, default: 'separate_route'

    def execute_devise_installer
      generate 'devise:install'
    end

    def execute_dta_installer
      # Necessary in case of a re-run of the generator, for DTA to detect concerns already included
      if File.exist?(File.expand_path("app/models/#{user_class.underscore}.rb", destination_root))
        gsub_file(
          "app/models/#{user_class.underscore}.rb",
          'GraphqlDevise::Concerns::Model',
          'DeviseTokenAuth::Concerns::User'
        )
      end
      gsub_file(
        'app/controllers/application_controller.rb',
        'GraphqlDevise::Concerns::SetUserByToken',
        'DeviseTokenAuth::Concerns::SetUserByToken'
      )

      generate 'devise_token_auth:install', "#{user_class} #{mount_path}"
    end

    def mount_resource_route
      routes_file = 'config/routes.rb'
      dta_route   = "mount_devise_token_auth_for '#{user_class}', at: '#{mount_path}'"

      if options['mount'] != 'separate_route'
        gsub_file(routes_file, /^\s+#{Regexp.escape(dta_route + "\n")}/i, '')
      else
        gem_route = "mount_graphql_devise_for '#{user_class}', at: '#{mount_path}'"

        if file_contains_str?(routes_file, gem_route)
          gsub_file(routes_file, /^\s+#{Regexp.escape(dta_route + "\n")}/i, '')

          say_status('skipped', "Routes already exist for #{user_class} at #{mount_path}")
        else
          gsub_file(routes_file, /#{Regexp.escape(dta_route)}/i, gem_route)
        end
      end
    end

    def replace_model_concern
      gsub_file(
        "app/models/#{user_class.underscore}.rb",
        /^\s+include DeviseTokenAuth::Concerns::User/,
        '  include GraphqlDevise::Concerns::Model'
      )
    end

    def replace_controller_concern
      gsub_file(
        'app/controllers/application_controller.rb',
        /^\s+include DeviseTokenAuth::Concerns::SetUserByToken/,
        '  include GraphqlDevise::Concerns::SetUserByToken'
      )
    end

    def set_change_headers_on_each_request_false
      gsub_file(
        'config/initializers/devise_token_auth.rb',
        '# config.change_headers_on_each_request = true',
        'config.change_headers_on_each_request = false'
      )
    end

    def mount_in_schema
      return if options['mount'] == 'separate_route'

      inject_into_file "app/graphql/#{options['mount'].underscore}.rb", after: "< GraphQL::Schema\n" do
<<-RUBY
  use GraphqlDevise::SchemaPlugin.new(
    query:            Types::QueryType,
    mutation:         Types::MutationType,
    resource_loaders: [
      GraphqlDevise::ResourceLoader.new(#{user_class})
    ]
  )
RUBY
      end
    end

    private

    def file_contains_str?(filename, regex_str)
      path = File.join(destination_root, filename)

      File.read(path) =~ /(#{Regexp.escape(regex_str)})/i
    end
  end
end
