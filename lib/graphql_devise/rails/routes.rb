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

    def mount_graphql_devise_for(resource, options = {})
      default_operations = GraphqlDevise::DefaultOperations::MUTATIONS.merge(GraphqlDevise::DefaultOperations::QUERIES)
      clean_options      = GraphqlDevise::MountMethod::OptionSanitizer.new(options).call!

      GraphqlDevise::MountMethod::OptionsValidator.new(
        [
          GraphqlDevise::MountMethod::OptionValidators::SkipOnlyValidator.new(options: clean_options),
          GraphqlDevise::MountMethod::OptionValidators::ProvidedOperationsValidator.new(
            options: clean_options, supported_operations: default_operations
          )
        ]
      ).validate!

      authenticatable_type = clean_options.authenticatable_type.presence ||
                             "Types::#{resource}Type".safe_constantize ||
                             GraphqlDevise::Types::AuthenticatableType

      param_operations = {
        custom:  clean_options.operations,
        only:    clean_options.only,
        skipped: clean_options.skip
      }

      devise_for(
        resource.pluralize.underscore.tr('/', '_').to_sym,
        module:     :devise,
        class_name: resource,
        skip:       DEVISE_OPERATIONS
      )

      prepared_mutations = GraphqlDevise::MountMethod::MutationsPreparer.call(
        resource:             resource,
        mutations:            GraphqlDevise::MountMethod::OperationSanitizer.call(
          default: GraphqlDevise::DefaultOperations::MUTATIONS, **param_operations
        ),
        authenticatable_type: authenticatable_type
      )

      prepared_queries = GraphqlDevise::MountMethod::QueriesPreparer.call(
        resource:             resource,
        queries:              GraphqlDevise::MountMethod::OperationSanitizer.call(
          default: GraphqlDevise::DefaultOperations::QUERIES, **param_operations
        ),
        authenticatable_type: authenticatable_type
      )

      all_mutations = prepared_mutations.merge(clean_options.additional_mutations)
      all_mutations.each do |action, mutation|
        GraphqlDevise::Types::MutationType.field(action, mutation: mutation)
      end

      if all_mutations.present? &&
         (Gem::Version.new(GraphQL::VERSION) < Gem::Version.new('1.10.0') || GraphqlDevise::Schema.mutation.nil?)
        GraphqlDevise::Schema.mutation(GraphqlDevise::Types::MutationType)
      end

      all_queries = prepared_queries.merge(clean_options.additional_queries)
      all_queries.each do |action, resolver|
        GraphqlDevise::Types::QueryType.field(action, resolver: resolver)
      end

      if all_queries.present? && GraphqlDevise::Types::QueryType.fields.blank?
        GraphqlDevise::Types::QueryType.field(:dummy, resolver: GraphqlDevise::Resolvers::Dummy)
      end

      Devise.mailer.helper(GraphqlDevise::MailerHelper)

      devise_scope resource.underscore.tr('/', '_').to_sym do
        post clean_options.at, to: 'graphql_devise/graphql#auth'
        get  clean_options.at, to: 'graphql_devise/graphql#auth'
      end
    end
  end
end
