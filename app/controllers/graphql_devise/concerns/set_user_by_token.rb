require 'devise_token_auth/concerns/set_user_by_token'

module GraphqlDevise
  module Concerns
    SetUserByToken = DeviseTokenAuth::Concerns::SetUserByToken
  end
end
