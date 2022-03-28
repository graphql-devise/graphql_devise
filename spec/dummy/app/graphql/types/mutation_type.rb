# frozen_string_literal: true

module Types
  class MutationType < BaseObject
    field_class GraphqlDevise::Types::BaseField if Gem::Version.new(GraphQL::VERSION) >= Gem::Version.new('2.0')

    field :dummy_mutation, String, null: false, authenticate: true
    field :update_user, mutation: Mutations::UpdateUser

    def dummy_mutation
      'Necessary so GraphQL gem does not complain about empty mutation type'
    end
  end
end
