# frozen_string_literal: true

module Mutations
  class Login < GraphqlDevise::Mutations::Login
    field :user, Types::UserType, null: true

    def resolve(email:, password:)
      original_payload = super do |user|
        user.do_something
        user.reload
      end

      original_payload.merge(user: original_payload[:authenticatable])
    end
  end
end
