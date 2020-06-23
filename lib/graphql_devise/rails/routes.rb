# frozen_string_literal: true

module ActionDispatch::Routing
  class Mapper
    def mount_graphql_devise_for(resource, options = {})
      clean_options = GraphqlDevise::ResourceLoader.new(resource, options, true).call(
        GraphqlDevise::Types::QueryType,
        GraphqlDevise::Types::MutationType
      )

      post clean_options.at, to: 'graphql_devise/graphql#auth'
      get  clean_options.at, to: 'graphql_devise/graphql#auth'
    end
  end
end
