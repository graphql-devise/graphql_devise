module ActionDispatch::Routing
  class Mapper
    def mount_graphql_devise_for(resource, opts = {})
      mutation_options = opts[:mutations] || {}
      query_options    = opts[:queries] || {}

      path         = opts.fetch(:at, '/')
      mapping_name = resource.underscore.tr('/', '_')

      devise_for(
        resource.pluralize.underscore.tr('/', '_').to_sym,
        module: :devise,
        skip:   [:sessions, :registrations, :passwords, :confirmations, :omniauth_callbacks, :unlocks]
      )

      authenticable_type = opts[:authenticable_type] ||
                           "Types::#{resource}Type".safe_constantize ||
                           GraphqlDevise::Types::AuthenticableType

      default_mutations = {
        login:               GraphqlDevise::Mutations::Login,
        logout:              GraphqlDevise::Mutations::Logout,
        sign_up:             GraphqlDevise::Mutations::SignUp,
        update_password:     GraphqlDevise::Mutations::UpdatePassword,
        send_reset_password: GraphqlDevise::Mutations::SendPasswordReset
      }.freeze

      default_mutations.each do |action, mutation|
        used_mutation = if mutation_options[action].present?
          mutation_options[action]
        else
          new_mutation = Class.new(mutation)
          new_mutation.graphql_name("#{resource}#{action.to_s.camelize(:upper)}")
          new_mutation.field(:authenticable, authenticable_type, null: true)

          new_mutation
        end

        GraphqlDevise::Types::MutationType.field("#{mapping_name}_#{action}", mutation: used_mutation)
      end

      default_queries = {
        confirm_account:      GraphqlDevise::Resolvers::ConfirmAccount,
        check_password_token: GraphqlDevise::Resolvers::CheckPasswordToken
      }

      default_queries.each do |action, query|
        used_query = if query_options[action].present?
          query_options[action]
        else
          new_query = Class.new(query)
          new_query.graphql_name("#{resource}#{action.to_s.camelize(:upper)}")
          new_query.type(authenticable_type, null: true)

          new_query
        end

        GraphqlDevise::Types::QueryType.field("#{mapping_name}_#{action}", resolver: used_query)
      end

      Devise.mailer.helper(GraphqlDevise::MailerHelper)

      devise_scope mapping_name.to_sym do
        post "#{path}/graphql_auth", to: 'graphql_devise/graphql#auth'
        get  "#{path}/graphql_auth", to: 'graphql_devise/graphql#auth'
      end
    end
  end
end
