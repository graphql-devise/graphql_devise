# frozen_string_literal: true

module ActionDispatch::Routing
  class Mapper
    def mount_graphql_devise_for(resource, opts = {})
      options = {
        skip: [
          :sessions,
          :registrations,
          :passwords,
          :confirmations,
          :token_validations,
          :omniauth_callbacks,
          :unlocks
        ]
      }.merge(opts)

      path         = opts.fetch(:at, '/')
      mapping_name = resource.underscore.tr('/', '_')

      devise_for(
        resource.pluralize.underscore.tr('/', '_').to_sym,
        class_name: resource,
        module:     :devise,
        path:       path,
        skip:       options[:skip] + [:omniauth_callbacks]
      )

      devise_scope mapping_name.to_sym do
        post "#{path}/graphql_auth", to: 'graphql_devise/graphql#auth'
      end
    end
  end
end
