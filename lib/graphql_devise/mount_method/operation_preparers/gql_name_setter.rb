# frozen_string_literal: true

module GraphqlDevise
  module MountMethod
    module OperationPreparers
      class GqlNameSetter
        def initialize(mapping_name)
          @mapping_name = mapping_name
        end

        def call(operation, **)
          operation.graphql_name(graphql_name)

          operation
        end

        private

        def graphql_name
          @mapping_name.camelize(:upper)
        end
      end
    end
  end
end
