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
      login:               { klass: GraphqlDevise::Mutations::Login, authenticable: true },
      logout:              { klass: GraphqlDevise::Mutations::Logout, authenticable: true },
      sign_up:             { klass: GraphqlDevise::Mutations::SignUp, authenticable: true },
      update_password:     { klass: GraphqlDevise::Mutations::UpdatePassword, authenticable: true },
      send_password_reset: { klass: GraphqlDevise::Mutations::SendPasswordReset, authenticable: true },
      resend_confirmation: { klass: GraphqlDevise::Mutations::ResendConfirmation, authenticable: true }

    }.freeze
  end
end
