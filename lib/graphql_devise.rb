require 'rails'
require 'graphql_devise/engine'
require 'devise_token_auth'
require 'graphql'
require 'graphql_devise/version'

module GraphqlDevise
  class Error < StandardError; end
end

require 'graphql_devise/user_error'
require 'graphql_devise/detailed_user_error'
