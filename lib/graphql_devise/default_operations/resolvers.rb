# frozen_string_literal: true

require 'graphql_devise/resolvers/base'
require 'graphql_devise/resolvers/check_password_token'
require 'graphql_devise/resolvers/confirm_account'

module GraphqlDevise
  module DefaultOperations
    QUERIES = {
      confirm_account:      { klass: GraphqlDevise::Resolvers::ConfirmAccount, deprecation_reason: 'use the new confirmation flow as it does not require this query anymore' },
      check_password_token: { klass: GraphqlDevise::Resolvers::CheckPasswordToken, deprecation_reason: 'use the new password reset flow as it does not require this query anymore' }
    }.freeze
  end
end
