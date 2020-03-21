module ActionDispatch::Routing
  class Mapper
    DEVISE_OPERATIONS = [
      :sessions,
      :registrations,
      :passwords,
      :confirmations,
      :omniauth_callbacks,
      :unlocks,
      :invitations
    ].freeze

    def mount_graphql_devise_for(resource, opts = {})
      custom_operations    = opts.fetch(:operations, {})
      skipped_operations   = opts.fetch(:skip, [])
      only_operations      = opts.fetch(:only, [])
      additional_mutations = opts.fetch(:additional_mutations, {})
      additional_queries   = opts.fetch(:additional_queries, {})
      path                 = opts.fetch(:at, '/graphql_auth')
      mapping_name         = resource.underscore.tr('/', '_').to_sym
      authenticatable_type = opts[:authenticatable_type].presence ||
        "Types::#{resource}Type".safe_constantize ||
        GraphqlDevise::Types::AuthenticatableType
      param_operations     = {
        custom:  custom_operations,
        only:    only_operations,
        skipped: skipped_operations
      }

      GraphqlDevise::OperationChecker.call(
        mutations: GraphqlDevise::MutationsPreparer::DEFAULT_MUTATIONS,
        queries:   GraphqlDevise::QueriesPreparer::DEFAULT_QUERIES,
        **param_operations
      )

      devise_for(
        resource.pluralize.underscore.tr('/', '_').to_sym,
        module:     :devise,
        class_name: resource,
        skip:       DEVISE_OPERATIONS
      )

      prepared_mutations = GraphqlDevise::MutationsPreparer.call(
        resource:             resource,
        mutations:            GraphqlDevise::OperationSanitizer.call(
          default: GraphqlDevise::MutationsPreparer::DEFAULT_MUTATIONS, **param_operations
        ),
        authenticatable_type: authenticatable_type
      )

      prepared_queries = GraphqlDevise::QueriesPreparer.call(
        resource:             resource,
        queries:              GraphqlDevise::OperationSanitizer.call(
          default: GraphqlDevise::QueriesPreparer::DEFAULT_QUERIES, **param_operations
        ),
        authenticatable_type: authenticatable_type
      )

      prepared_mutations.merge(additional_mutations).each do |action, mutation|
        GraphqlDevise::Types::MutationType.field(action, mutation: mutation)
      end

      if (prepared_mutations.present? || additional_mutations.present?) &&
          (Gem::Version.new(GraphQL::VERSION) <= Gem::Version.new('1.10.0') || GraphqlDevise::Schema.mutation.nil?)
        GraphqlDevise::Schema.mutation(GraphqlDevise::Types::MutationType)
      end

      prepared_queries.merge(additional_queries).each do |action, resolver|
        GraphqlDevise::Types::QueryType.field(action, resolver: resolver)
      end

      if (prepared_queries.blank? || additional_queries.present?) && GraphqlDevise::Types::QueryType.fields.blank?
        GraphqlDevise::Types::QueryType.field(:dummy, resolver: GraphqlDevise::Resolvers::Dummy)
      end

      Devise.mailer.helper(GraphqlDevise::MailerHelper)

      devise_scope mapping_name do
        post path, to: 'graphql_devise/graphql#auth'
        get  path, to: 'graphql_devise/graphql#auth'
      end
    end
  end
end
