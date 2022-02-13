# frozen_string_literal: true

module GraphqlDevise
  module DefaultOperations
    QUERIES = {}.freeze
    MUTATIONS = {
      login:                           { klass: Mutations::Login, authenticatable: true },
      logout:                          { klass: Mutations::Logout, authenticatable: true },
      register:                        { klass: Mutations::Register, authenticatable: true },
      update_password_with_token:      { klass: Mutations::UpdatePasswordWithToken, authenticatable: true },
      send_password_reset_with_token:  { klass: Mutations::SendPasswordResetWithToken, authenticatable: false },
      resend_confirmation_with_token:  { klass: Mutations::ResendConfirmationWithToken, authenticatable: false },
      confirm_registration_with_token: { klass: Mutations::ConfirmRegistrationWithToken, authenticatable: true }
    }.freeze
  end
end
