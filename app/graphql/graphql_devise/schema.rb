module GraphqlDevise
  class Schema < GraphQL::Schema
    mutation(GraphqlDevise::Types::MutationType)
    query(GraphqlDevise::Types::QueryType)
  end
end
