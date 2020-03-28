require 'graphql_devise/mutations/base'
require 'graphql_devise/mutations/login'
require 'graphql_devise/mutations/logout'
require 'graphql_devise/mutations/resend_confirmation'
require 'graphql_devise/mutations/send_password_reset'
require 'graphql_devise/mutations/sign_up'
require 'graphql_devise/mutations/update_password'

module GraphqlDevise
  module DefaultOperations
    MUTATIONS = {
      login:               GraphqlDevise::Mutations::Login,
      logout:              GraphqlDevise::Mutations::Logout,
      sign_up:             GraphqlDevise::Mutations::SignUp,
      update_password:     GraphqlDevise::Mutations::UpdatePassword,
      send_password_reset: GraphqlDevise::Mutations::SendPasswordReset,
      resend_confirmation: GraphqlDevise::Mutations::ResendConfirmation
    }.freeze
  end
end
