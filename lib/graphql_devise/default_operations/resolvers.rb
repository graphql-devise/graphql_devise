require 'graphql_devise/resolvers/base'
require 'graphql_devise/resolvers/check_password_token'
require 'graphql_devise/resolvers/confirm_account'

module GraphqlDevise
  module DefaultOperations
    QUERIES = {
      confirm_account:      GraphqlDevise::Resolvers::ConfirmAccount,
      check_password_token: GraphqlDevise::Resolvers::CheckPasswordToken
    }.freeze
  end
end
