# frozen_string_literal: true

module GraphqlDevise
  module Types
    class AuthenticatableType < GraphQL::Schema::Object
      field :email, String, null: false
    end
  end
end
