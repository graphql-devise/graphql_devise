# frozen_string_literal: true

require_dependency 'graphql_devise/application_controller'

module GraphqlDevise
  class GraphqlController < ApplicationController
    include SetUserByToken
    include AuthControllerMethods
  end
end
