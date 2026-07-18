module GraphqlDevise
  module RouteMounter
    def mount_graphql_devise_for(resource, options = {})
      routing = auth_routing(resource, options.delete(:base_controller))

      clean_options = ResourceLoader.new(resource, options, true).call(
        Types::QueryType,
        Types::MutationType
      )

      require_introspection_auth(clean_options)

      post clean_options.at, to: routing
      get  clean_options.at, to: routing
    end

    private

    def auth_routing(resource, base_controller)
      return 'graphql_devise/graphql#auth' if base_controller.blank?

      new_controller = GraphqlDevise.const_set("#{resource}AuthController", Class.new(base_controller))
      new_controller.include(SetUserByToken)
      new_controller.include(AuthControllerMethods)

      "#{new_controller.to_s.underscore.gsub('_controller', '')}#auth"
    end

    def require_introspection_auth(clean_options)
      return if clean_options.public_introspection || GraphqlDevise.introspection_plugin_applied?

      Schema.use(SchemaPlugin.new(authenticate_default: true, public_introspection: false))
      GraphqlDevise.introspection_plugin_applied!
    end
  end
end
