# frozen_string_literal: true

module GraphqlDevise
  module DefaultOperations
    QUERIES = {}.freeze
    MUTATIONS = {
      login:                           { klass: GraphqlDevise::Mutations::Login, authenticatable: true },
      logout:                          { klass: GraphqlDevise::Mutations::Logout, authenticatable: true },
      register:                        { klass: GraphqlDevise::Mutations::Register, authenticatable: true },
      update_password_with_token:      { klass: GraphqlDevise::Mutations::UpdatePasswordWithToken, authenticatable: true },
      send_password_reset_with_token:  { klass: GraphqlDevise::Mutations::SendPasswordResetWithToken, authenticatable: false },
      resend_confirmation_with_token:  { klass: GraphqlDevise::Mutations::ResendConfirmationWithToken, authenticatable: false },
      confirm_registration_with_token: { klass: GraphqlDevise::Mutations::ConfirmRegistrationWithToken, authenticatable: true }
    }.freeze
  end
end
