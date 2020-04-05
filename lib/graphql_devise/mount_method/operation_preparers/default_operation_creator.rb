module GraphqlDevise
  module MountMethod
    module OperationPreparers
      class DefaultOperationCreator
        def initialize(operation, gql_name)
          @operation = operation
          @gql_name = gql_name
        end

        def call
          new_operation = Class.new(@operation)
          new_operation.graphql_name(@gql_name)

          new_operation
        end
      end
    end
  end
end
