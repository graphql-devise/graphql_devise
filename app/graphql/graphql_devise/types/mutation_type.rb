module GraphqlDevise
  module Types
    class MutationType < GraphQL::Schema::Object
      field :login, mutation: GraphqlDevise::Mutations::Login
    end
  end
end
