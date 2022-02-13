# frozen_string_literal: true

module GraphqlDevise
  class SchemaPlugin
    # NOTE: Based on GQL-Ruby docs  https://graphql-ruby.org/schema/introspection.html
    INTROSPECTION_FIELDS = ['__schema', '__type', '__typename']
    DEFAULT_NOT_AUTHENTICATED = ->(field) { raise AuthenticationError, "#{field} field requires authentication" }

    def initialize(query: nil, mutation: nil, authenticate_default: true, public_introspection: !Rails.env.production?, resource_loaders: [], unauthenticated_proc: DEFAULT_NOT_AUTHENTICATED)
      @query                = query
      @mutation             = mutation
      @resource_loaders     = resource_loaders
      @authenticate_default = authenticate_default
      @public_introspection = public_introspection
      @unauthenticated_proc = unauthenticated_proc

      # Must happen on initialize so operations are loaded before the types are added to the schema on GQL < 1.10
      load_fields
    end

    def use(schema_definition)
      schema_definition.tracer(self)
    end

    def trace(event, trace_data)
      # Authenticate only root level queries
      return yield unless event == 'execute_field' && path(trace_data).count == 1

      field         = traced_field(trace_data)
      auth_required = authenticate_option(field, trace_data)
      context       = context_from_data(trace_data)

      if auth_required && !(public_introspection && introspection_field?(field))
        raise_on_missing_resource(context, field, auth_required)
      end

      yield
    end

    private

    attr_reader :public_introspection

    def raise_on_missing_resource(context, field, auth_required)
      @unauthenticated_proc.call(field.name) if context[:current_resource].blank?

      if auth_required.respond_to?(:call) && !auth_required.call(context[:current_resource])
        @unauthenticated_proc.call(field.name)
      end
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
      auth_required = if trace_data[:context]
        field.metadata[:authenticate]
      else
        field.graphql_definition.metadata[:authenticate]
      end

      auth_required.nil? ? @authenticate_default : auth_required
    end

    def load_fields
      @resource_loaders.each do |resource_loader|
        raise Error, 'Invalid resource loader instance' unless resource_loader.instance_of?(ResourceLoader)

        resource_loader.call(@query, @mutation)
      end
    end

    def introspection_field?(field)
      INTROSPECTION_FIELDS.include?(field.name)
    end
  end
end

