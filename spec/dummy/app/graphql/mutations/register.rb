# frozen_string_literal: true

module Mutations
  class Register < GraphqlDevise::Mutations::Register
    argument :name, String, required: false

    field :user, Types::UserType, null: true

    def resolve(email:, **attrs)
      original_payload = super
      original_payload.merge(user: original_payload[:authenticatable])
    end
  end
end
