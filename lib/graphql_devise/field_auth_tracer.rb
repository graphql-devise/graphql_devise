# frozen_string_literal: true

module GraphqlDevise
  module FieldAuthTracer
    def initialize(authenticate_default:, public_introspection:, unauthenticated_proc:, **_rest)
      @authenticate_default = authenticate_default
      @public_introspection = public_introspection
      @unauthenticated_proc = unauthenticated_proc

      super
    end

    def execute_field(field:, query:, ast_node:, arguments:, object:)
      # Authenticate only root level queries
      return super unless query.context.current_path.count == 1

      auth_required = authenticate_option(field)

      if auth_required && !(public_introspection && introspection_field?(field.name))
        raise_on_missing_resource(query.context, field, auth_required)
      end

      super
    end

    private

    attr_reader :public_introspection

    def authenticate_option(field)
      auth_required = field.try(:authenticate)

      auth_required.nil? ? @authenticate_default : auth_required
    end

    def introspection_field?(field_name)
      SchemaPlugin::INTROSPECTION_FIELDS.include?(field_name.downcase)
    end

    def raise_on_missing_resource(context, field, auth_required)
      @unauthenticated_proc.call(field.name) if context[:current_resource].blank?

      if auth_required.respond_to?(:call) && !auth_required.call(context[:current_resource])
        @unauthenticated_proc.call(field.name)
      end
    end
  end
end
