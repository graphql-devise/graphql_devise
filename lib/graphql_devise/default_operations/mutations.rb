# frozen_string_literal: true

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
      login:               { klass: GraphqlDevise::Mutations::Login, authenticatable: true },
      logout:              { klass: GraphqlDevise::Mutations::Logout, authenticatable: true },
      sign_up:             { klass: GraphqlDevise::Mutations::SignUp, authenticatable: true },
      update_password:     { klass: GraphqlDevise::Mutations::UpdatePassword, authenticatable: true },
      send_password_reset: { klass: GraphqlDevise::Mutations::SendPasswordReset, authenticatable: false },
      resend_confirmation: { klass: GraphqlDevise::Mutations::ResendConfirmation, authenticatable: false }
    }.freeze
  end
end
