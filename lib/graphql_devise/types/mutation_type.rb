# frozen_string_literal: true

module GraphqlDevise
  module Types
    class MutationType < GraphQL::Schema::Object
      field_class GraphqlDevise::Types::BaseField if Gem::Version.new(GraphQL::VERSION) >= Gem::Version.new('2.0')
    end
  end
end
