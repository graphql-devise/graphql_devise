# frozen_string_literal: true

module GraphqlDevise
  class ResourceLoader
    def initialize(resource, options = {}, routing = false)
      @resource           = resource
      @options            = options
      @routing            = routing
      @default_operations = DefaultOperations::MUTATIONS.merge(DefaultOperations::QUERIES)
    end

    def call(query, mutation)
      # clean_options responds to all keys defined in GraphqlDevise::MountMethod::SUPPORTED_OPTIONS
      clean_options = MountMethod::OptionSanitizer.new(@options).call!

      unless @resource.is_a?(Class)
        raise(
          InvalidMountOptionsError,
          'A class must be provided when mounting a model. String values are no longer supported.'
        )
      end

      # Necesary when mounting a resource via route file as Devise forces the reloading of routes
      return clean_options if ::GraphqlDevise.resource_mounted?(@resource) && @routing

      validate_options!(clean_options)

      authenticatable_type = clean_options.authenticatable_type.presence ||
                             "Types::#{@resource}Type".safe_constantize ||
                             Types::AuthenticatableType

      prepared_mutations = prepare_mutations(@resource, clean_options, authenticatable_type)

      if prepared_mutations.any? && mutation.blank?
        raise ::GraphqlDevise::Error, 'You need to provide a mutation type unless all mutations are skipped'
      end

      begin
        prepared_mutations.each do |action, prepared_mutation|
          mutation.field(action, mutation: prepared_mutation, authenticate: false)
        end
      rescue ArgumentError
        raise unless Gem::Version.new(GraphQL::VERSION) >= Gem::Version.new('2.0')

        raise_undefined_field_class_error('MutationType')
      end

      prepared_resolvers = prepare_resolvers(@resource, clean_options, authenticatable_type)

      if prepared_resolvers.any? && query.blank?
        raise ::GraphqlDevise::Error, 'You need to provide a query type unless all queries are skipped'
      end

      begin
        prepared_resolvers.each do |action, resolver|
          query.field(action, resolver: resolver, authenticate: false)
        end
      rescue ArgumentError
        raise unless Gem::Version.new(GraphQL::VERSION) >= Gem::Version.new('2.0')

        raise_undefined_field_class_error('QueryType')
      end

      ::GraphqlDevise.add_mapping(::GraphqlDevise.to_mapping_name(@resource).to_sym, @resource)
      ::GraphqlDevise.mount_resource(@resource) if @routing

      clean_options
    end

    private

    def raise_undefined_field_class_error(type_class)
      raise(
        GraphqlDevise::Error,
        <<~MESSAGE
          To use this gem with graphql >= 2.0 you need to use a custom `field_class`
          on your #{type_class}. You can use the `field_class` defined in this gem like this:

          module Types
            class #{type_class} < GraphQL::Schema::Object
              field_class GraphqlDevise::Types::BaseField
            end
          end

          If you already have a `field_class` set on your #{type_class}, you can include our concern
          to make this work

          module Types
            class BaseField < GraphQL::Schema::Field
              include GraphqlDevise::FieldAuthentication
            end
          end

          The concern will define an initializer, if your custom field logic is not standard, you can look
          at the `GraphqlDevise::FieldAuthentication` implementation to add what is required to your own
          field class
        MESSAGE
      )
    end

    def prepare_resolvers(model, clean_options, authenticatable_type)
      MountMethod::OperationPreparer.new(
        model:                 model,
        custom:                clean_options.operations,
        additional_operations: clean_options.additional_queries,
        preparer:              MountMethod::OperationPreparers::ResolverTypeSetter.new(authenticatable_type),
        selected_operations:   MountMethod::OperationSanitizer.call(
          default: DefaultOperations::QUERIES, only: clean_options.only, skipped: clean_options.skip
        )
      ).call
    end

    def prepare_mutations(model, clean_options, authenticatable_type)
      MountMethod::OperationPreparer.new(
        model:                 model,
        custom:                clean_options.operations,
        additional_operations: clean_options.additional_mutations,
        preparer:              MountMethod::OperationPreparers::MutationFieldSetter.new(authenticatable_type),
        selected_operations:   MountMethod::OperationSanitizer.call(
          default: DefaultOperations::MUTATIONS, only: clean_options.only, skipped: clean_options.skip
        )
      ).call
    end

    def validate_options!(clean_options)
      MountMethod::OptionsValidator.new(
        [
          MountMethod::OptionValidators::SkipOnlyValidator.new(options: clean_options),
          MountMethod::OptionValidators::ProvidedOperationsValidator.new(
            options: clean_options, supported_operations: @default_operations
          )
        ]
      ).validate!
    end
  end
end
