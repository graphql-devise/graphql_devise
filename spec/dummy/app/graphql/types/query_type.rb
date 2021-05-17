# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :user, resolver: Resolvers::UserShow
    field :public_field, String, null: false, authenticate: false
    field :private_field, String, null: false, authenticate: true
    field :vip_field, String, null: false, authenticate: ->(user) { user.is_a?(User) && user.vip? }

    def public_field
      'Field does not require authentication'
    end

    def private_field
      'Field will always require authentication'
    end

    def vip_field
      'Field available only for VIP Users'
    end
  end
end
