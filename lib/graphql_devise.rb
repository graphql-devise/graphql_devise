require 'rails'
require 'graphql_devise/engine'
require 'devise_token_auth'
require 'graphql'
require 'graphql_devise/version'
require 'graphql_devise/util/class_getter'

module GraphqlDevise
  class Error < StandardError; end
end
