module GraphqlDevise
  module Types
    class AuthenticatableType < GraphQL::Schema::Object
      field :email, String, null: false
    end
  end
end
