module GraphqlDevise
  module RouteMounter
    def mount_graphql_devise_for(resource, options = {})
      clean_options = ResourceLoader.new(resource, options, true).call(
        Types::QueryType,
        Types::MutationType
      )

      post clean_options.at, to: 'graphql_devise/graphql#auth'
      get  clean_options.at, to: 'graphql_devise/graphql#auth'
    end
  end
end
