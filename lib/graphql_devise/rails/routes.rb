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

      validate_gql_devise_operations!(param_operations)

      devise_for(
        resource.pluralize.underscore.tr('/', '_').to_sym,
        module: :devise,
        skip:   [DEVISE_OPERATIONS]
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

      add_gql_devise_mutations!(prepared_mutations, additional_mutations)
      add_gql_devise_queries!(prepared_queries, additional_queries)

      Devise.mailer.helper(GraphqlDevise::MailerHelper)

      devise_scope mapping_name do
        post path, to: 'graphql_devise/graphql#auth'
        get  path, to: 'graphql_devise/graphql#auth'
      end
    end

    private

    def validate_gql_devise_operations!(param_operations)
      GraphqlDevise::OperationChecker.call(
        mutations: GraphqlDevise::MutationsPreparer::DEFAULT_MUTATIONS,
        queries:   GraphqlDevise::QueriesPreparer::DEFAULT_QUERIES,
        **param_operations
      )
    end

    def add_gql_devise_mutations!(prepared, additional)
      all_mutations = prepared.merge(additional)

      all_mutations.each do |action, mutation|
        GraphqlDevise::Types::MutationType.field(action, mutation: mutation)
      end

      if all_mutations.present? && GraphqlDevise::Schema.try(:mutation).nil?
        GraphqlDevise::Schema.mutation(GraphqlDevise::Types::MutationType)
      end
    end

    def add_gql_devise_queries!(prepared, additional)
      prepared.merge(additional).each do |action, resolver|
        GraphqlDevise::Types::QueryType.field(action, resolver: resolver)
      end

      if (prepared.blank? || additional.present?) && GraphqlDevise::Types::QueryType.fields.blank?
        GraphqlDevise::Types::QueryType.field(:dummy, resolver: GraphqlDevise::Resolvers::Dummy)
      end
    end
  end
end
