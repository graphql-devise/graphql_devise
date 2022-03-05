# frozen_string_literal: true

require 'devise_token_auth/version'

module GraphqlDevise
  module Mutations
    class Base < GraphQL::Schema::Mutation
      include ControllerMethods
    end
  end
end
