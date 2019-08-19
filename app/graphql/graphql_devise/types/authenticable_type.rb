module GraphqlDevise
  module Types
    class AuthenticableType < GraphQL::Schema::Object
      field :email, String, null: false
    end
  end
end
