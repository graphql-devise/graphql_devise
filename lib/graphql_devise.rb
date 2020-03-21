require 'rails'
require 'graphql'
require 'devise_token_auth'

require 'graphql_devise/concerns/controller_methods'
require 'graphql_devise/types/authenticatable_type'
require 'graphql_devise/types/credential_type'
require 'graphql_devise/types/mutation_type'
require 'graphql_devise/types/query_type'
require 'graphql_devise/mutations/base'
require 'graphql_devise/mutations/login'
require 'graphql_devise/mutations/logout'
require 'graphql_devise/mutations/resend_confirmation'
require 'graphql_devise/mutations/send_password_reset'
require 'graphql_devise/mutations/sign_up'
require 'graphql_devise/mutations/update_password'
require 'graphql_devise/resolvers/base'
require 'graphql_devise/resolvers/check_password_token'
require 'graphql_devise/resolvers/confirm_account'
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
