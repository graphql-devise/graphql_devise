module GraphqlDevise
  class SchemaPlugin
    DEFAULT_NOT_AUTHENTICATED = ->(field) { raise GraphqlDevise::AuthenticationError, "#{field} field requires authentication" }

    def initialize(query: nil, mutation: nil, authenticate_default: true, resource_loaders: [], unauthenticated_proc: DEFAULT_NOT_AUTHENTICATED)
      @query                = query
      @mutation             = mutation
      @resource_loaders     = resource_loaders
      @authenticate_default = authenticate_default
      @unauthenticated_proc = unauthenticated_proc

      # Must happen on initialize so operations are loaded before the types are added to the schema on GQL < 1.10
      load_fields
      reconfigure_warden!
    end

    def use(schema_definition)
      schema_definition.tracer(self)
    end

    def trace(event, trace_data)
      # Authenticate only root level queries
      return yield unless event == 'execute_field' && path(trace_data).count == 1

      field = traced_field(trace_data)
      provided_value = authenticate_option(field, trace_data)
      context = set_current_resource(context_from_data(trace_data))

      if !provided_value.nil?
        raise_on_missing_resource(context, field) if provided_value
      elsif @authenticate_default
        raise_on_missing_resource(context, field)
      end

      yield
    end

    private

    def set_current_resource(context)
      controller                 = context[:controller]
      resource_names             = Array(context[:resource_name])
      context[:current_resource] = resource_names.find do |resource_name|
        unless Devise.mappings.key?(resource_name)
          raise(
            GraphqlDevise::Error,
            "Invalid resource_name `#{resource_name}` provided to `graphql_context`. Possible values are: #{Devise.mappings.keys}."
          )
        end

        found = controller.set_resource_by_token(resource_name)
        break found if found
      end

      context
    end

    def raise_on_missing_resource(context, field)
      @unauthenticated_proc.call(field.name) if context[:current_resource].blank?
    end

    def context_from_data(trace_data)
      query = if trace_data[:context]
        trace_data[:context].query
      else
        trace_data[:query]
      end

      query.context
    end

    def path(trace_data)
      if trace_data[:context]
        trace_data[:context].path
      else
        trace_data[:path]
      end
    end

    def traced_field(trace_data)
      if trace_data[:context]
        trace_data[:context].field
      else
        trace_data[:field]
      end
    end

    def authenticate_option(field, trace_data)
      if trace_data[:context]
        field.metadata[:authenticate]
      else
        field.graphql_definition.metadata[:authenticate]
      end
    end

    def reconfigure_warden!
      Devise.class_variable_set(:@@warden_configured, nil)
      Devise.configure_warden!
    end

    def load_fields
      @resource_loaders.each do |resource_loader|
        raise Error, 'Invalid resource loader instance' unless resource_loader.instance_of?(GraphqlDevise::ResourceLoader)

        resource_loader.call(@query, @mutation)
      end
    end
  end
end

GraphQL::Field.accepts_definitions(authenticate: GraphQL::Define.assign_metadata_key(:authenticate))
GraphQL::Schema::Field.accepts_definition(:authenticate)
