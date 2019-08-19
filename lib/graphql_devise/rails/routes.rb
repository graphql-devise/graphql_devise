# frozen_string_literal: true

module ActionDispatch::Routing
  class Mapper
    def mount_graphql_devise_for(resource, opts = {})
      mount_devise_token_auth_for(
        resource,
        {
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
      )

      path         = opts.fetch(:at, '/')
      mapping_name = resource.underscore.gsub('/', '_')

      devise_scope mapping_name.to_sym do
        post "#{path}/graphql_auth", to: 'graphql_devise/graphql#auth'
      end
    end
  end
end
