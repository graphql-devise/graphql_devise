# frozen_string_literal: true

module Resolvers
  class ConfirmAdminAccount < GraphqlDevise::Resolvers::ConfirmAccount
    type Types::AdminType, null: false

    def resolve(confirmation_token:, redirect_url:)
      super do |admin|
        controller.sign_in(admin)
      end
    end
  end
end
