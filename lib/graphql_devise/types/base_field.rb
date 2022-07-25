# frozen_string_literal: true

module GraphqlDevise
  module Types
    class BaseField < GraphQL::Schema::Field
      include FieldAuthentication
    end
  end
end
