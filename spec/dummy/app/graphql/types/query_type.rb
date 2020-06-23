# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :user, resolver: Resolvers::UserShow
    field :public_field, String, null: false, authenticate: false
    field :private_field, String, null: false, authenticate: true

    def public_field
      'Field does not require authentication'
    end

    def private_field
      'Field will always require authentication'
    end
  end
end
