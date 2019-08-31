require 'rails'
require 'devise_token_auth'
require 'graphql_devise/engine'
require 'graphql'
require 'graphql_devise/version'
require 'graphql_devise/error_codes'
require 'graphql_devise/user_error'
require 'graphql_devise/detailed_user_error'

module GraphqlDevise
  class Error < StandardError; end
end
