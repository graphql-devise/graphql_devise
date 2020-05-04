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

      # clean_options responds to all keys defined in GraphqlDevise::MountMethod::SUPPORTED_OPTIONS
      clean_options = GraphqlDevise::MountMethod::OptionSanitizer.new(options).call!

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

      devise_for(
        resource.pluralize.underscore.tr('/', '_').to_sym,
        module:     :devise,
        class_name: resource,
        skip:       DEVISE_OPERATIONS
      )

      prepared_mutations = GraphqlDevise::MountMethod::OperationPreparer.new(
        resource:              resource,
        custom:                clean_options.operations,
        additional_operations: clean_options.additional_mutations,
        preparer:              GraphqlDevise::MountMethod::OperationPreparers::MutationFieldSetter.new(authenticatable_type),
        selected_operations:   GraphqlDevise::MountMethod::OperationSanitizer.call(
          default: GraphqlDevise::DefaultOperations::MUTATIONS, only: clean_options.only, skipped: clean_options.skip
        )
      ).call

      prepared_mutations.each do |action, mutation|
        GraphqlDevise::Types::MutationType.field(action, mutation: mutation)
      end

      if prepared_mutations.present? &&
         (Gem::Version.new(GraphQL::VERSION) < Gem::Version.new('1.10.0') || GraphqlDevise::Schema.mutation.nil?)
        GraphqlDevise::Schema.mutation(GraphqlDevise::Types::MutationType)
      end

      prepared_queries = GraphqlDevise::MountMethod::OperationPreparer.new(
        resource:              resource,
        custom:                clean_options.operations,
        additional_operations: clean_options.additional_queries,
        preparer:              GraphqlDevise::MountMethod::OperationPreparers::ResolverTypeSetter.new(authenticatable_type),
        selected_operations:   GraphqlDevise::MountMethod::OperationSanitizer.call(
          default: GraphqlDevise::DefaultOperations::QUERIES, only: clean_options.only, skipped: clean_options.skip
        )
      ).call

      prepared_queries.each do |action, resolver|
        GraphqlDevise::Types::QueryType.field(action, resolver: resolver)
      end

      if prepared_queries.blank? && GraphqlDevise::Types::QueryType.fields.blank?
        GraphqlDevise::Types::QueryType.field(:dummy, resolver: GraphqlDevise::Resolvers::Dummy)
      end

      if prepared_queries.present? &&
        (Gem::Version.new(GraphQL::VERSION) < Gem::Version.new('1.10.0') || GraphqlDevise::Schema.query.nil?)
        GraphqlDevise::Schema.query(GraphqlDevise::Types::QueryType)
      end

      Devise.mailer.helper(GraphqlDevise::MailerHelper)

      devise_scope resource.underscore.tr('/', '_').to_sym do
        post clean_options.at, to: 'graphql_devise/graphql#auth'
        get  clean_options.at, to: 'graphql_devise/graphql#auth'
      end
    end
  end
end
