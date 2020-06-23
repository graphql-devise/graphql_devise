# frozen_string_literal: true

require 'graphql_devise/rails/routes'

module GraphqlDevise
  class Engine < ::Rails::Engine
    isolate_namespace GraphqlDevise
  end
end
