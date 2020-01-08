module GraphqlDevise
  class Schema < GraphQL::Schema
    query(GraphqlDevise::Types::QueryType)
  end
end
