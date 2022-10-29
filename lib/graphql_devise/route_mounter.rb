module GraphqlDevise
  module RouteMounter
    def mount_graphql_devise_for(resource, options = {})
      routing = 'graphql_devise/graphql#auth'

      if (base_controller = options.delete(:base_controller))
        new_controller = GraphqlDevise.const_set("#{resource}AuthController", Class.new(base_controller))
        new_controller.include(SetUserByToken)
        new_controller.include(AuthControllerMethods)

        routing = "#{new_controller.to_s.underscore.gsub('_controller','')}#auth"
      end

      clean_options = ResourceLoader.new(resource, options, true).call(
        Types::QueryType,
        Types::MutationType
      )

      post clean_options.at, to: routing
      get  clean_options.at, to: routing
    end
  end
end
