require 'rails'
require 'graphql'
require 'devise_token_auth'

require 'graphql_devise/concerns/controller_methods'
require 'graphql_devise/types/authenticatable_type'
require 'graphql_devise/types/credential_type'
require 'graphql_devise/types/mutation_type'
require 'graphql_devise/types/query_type'
require 'graphql_devise/default_operations/mutations'
require 'graphql_devise/default_operations/resolvers'
require 'graphql_devise/resolvers/dummy'

require 'graphql_devise/engine'
require 'graphql_devise/version'
require 'graphql_devise/error_codes'
require 'graphql_devise/user_error'
require 'graphql_devise/detailed_user_error'

require 'graphql_devise/rails/queries_preparer'
require 'graphql_devise/rails/mutations_preparer'
require 'graphql_devise/rails/operation_checker'
require 'graphql_devise/rails/operation_sanitizer'

module GraphqlDevise
  class Error < StandardError; end
end
