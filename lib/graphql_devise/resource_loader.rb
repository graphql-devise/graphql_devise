module GraphqlDevise
  class ResourceLoader
    def initialize(resource, options = {}, routing = false)
      @resource           = resource
      @options            = options
      @routing            = routing
      @default_operations = GraphqlDevise::DefaultOperations::MUTATIONS.merge(GraphqlDevise::DefaultOperations::QUERIES)
    end

    def call(query, mutation)
      mapping_name = @resource.to_s.underscore.tr('/', '_').to_sym

      # clean_options responds to all keys defined in GraphqlDevise::MountMethod::SUPPORTED_OPTIONS
      clean_options = GraphqlDevise::MountMethod::OptionSanitizer.new(@options).call!

      return clean_options if GraphqlDevise.resource_mounted?(mapping_name) && @routing

      validate_options!(clean_options)

      authenticatable_type = clean_options.authenticatable_type.presence ||
                             "Types::#{@resource}Type".safe_constantize ||
                             GraphqlDevise::Types::AuthenticatableType

      prepared_mutations = prepare_mutations(mapping_name, clean_options, authenticatable_type)

      if prepared_mutations.any? && mutation.blank?
        raise GraphqlDevise::Error, 'You need to provide a mutation type unless all mutations are skipped'
      end

      prepared_mutations.each do |action, prepared_mutation|
        mutation.field(action, mutation: prepared_mutation, authenticate: false)
      end

      prepared_resolvers = prepare_resolvers(mapping_name, clean_options, authenticatable_type)

      if prepared_resolvers.any? && query.blank?
        raise GraphqlDevise::Error, 'You need to provide a query type unless all queries are skipped'
      end

      prepared_resolvers.each do |action, resolver|
        query.field(action, resolver: resolver, authenticate: false)
      end

      GraphqlDevise.add_mapping(mapping_name, @resource)
      GraphqlDevise.mount_resource(mapping_name) if @routing

      clean_options
    end

    private

    def prepare_resolvers(mapping_name, clean_options, authenticatable_type)
      GraphqlDevise::MountMethod::OperationPreparer.new(
        mapping_name:          mapping_name,
        custom:                clean_options.operations,
        additional_operations: clean_options.additional_queries,
        preparer:              GraphqlDevise::MountMethod::OperationPreparers::ResolverTypeSetter.new(authenticatable_type),
        selected_operations:   GraphqlDevise::MountMethod::OperationSanitizer.call(
          default: GraphqlDevise::DefaultOperations::QUERIES, only: clean_options.only, skipped: clean_options.skip
        )
      ).call
    end

    def prepare_mutations(mapping_name, clean_options, authenticatable_type)
      GraphqlDevise::MountMethod::OperationPreparer.new(
        mapping_name:          mapping_name,
        custom:                clean_options.operations,
        additional_operations: clean_options.additional_mutations,
        preparer:              GraphqlDevise::MountMethod::OperationPreparers::MutationFieldSetter.new(authenticatable_type),
        selected_operations:   GraphqlDevise::MountMethod::OperationSanitizer.call(
          default: GraphqlDevise::DefaultOperations::MUTATIONS, only: clean_options.only, skipped: clean_options.skip
        )
      ).call
    end

    def validate_options!(clean_options)
      GraphqlDevise::MountMethod::OptionsValidator.new(
        [
          GraphqlDevise::MountMethod::OptionValidators::SkipOnlyValidator.new(options: clean_options),
          GraphqlDevise::MountMethod::OptionValidators::ProvidedOperationsValidator.new(
            options: clean_options, supported_operations: @default_operations
          )
        ]
      ).validate!
    end
  end
end
