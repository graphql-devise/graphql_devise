require 'devise_token_auth/concerns/user'

module GraphqlDevise
  module Concerns
    Model = DeviseTokenAuth::Concerns::User
  end
end
