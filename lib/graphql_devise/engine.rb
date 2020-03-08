require 'graphql_devise/rails/routes'

module GraphqlDevise
  class Engine < ::Rails::Engine
    isolate_namespace GraphqlDevise

    config.before_initialize do
      GraphqlDevise::Schema.mutation(GraphqlDevise::Types::MutationType)

      if GraphqlDevise::Types::QueryType.fields.blank?
        GraphqlDevise::Types::QueryType.field(:dummy, resolver: GraphqlDevise::Resolvers::Dummy)
      end
    end
  end
end
