class DummySchema < GraphQL::Schema
  use GraphqlDevise::SchemaPlugin.new(query: Types::QueryType)

  mutation(Types::MutationType)
  query(Types::QueryType)
end
