# frozen_string_literal: true

module GraphqlDevise
  module Resolvers
    class Dummy < Base
      type String, null: false
      description 'Field necessary as at least one query must be present in the schema'

      def resolve
        'Dummy field necessary as graphql-ruby gem requires at least one query to be present in the schema.'
      end
    end
  end
end
