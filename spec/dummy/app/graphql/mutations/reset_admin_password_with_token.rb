# frozen_string_literal: true

module Mutations
  class ResetAdminPasswordWithToken < GraphqlDevise::Mutations::UpdatePasswordWithToken
    field :authenticatable, Types::AdminType, null: false

    def resolve(reset_password_token:, **attrs)
      super do |admin|
        controller.sign_in(admin)
      end
    end
  end
end
