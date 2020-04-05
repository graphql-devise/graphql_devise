module GraphqlDevise
  module MountMethod
    module OperationPreparers
      class ResourceNameSetter
        def initialize(operation, name)
          @operation = operation
          @name      = name
        end

        def call
          @operation.instance_variable_set(:@resource_name, @name.to_sym)

          @operation
        end
      end
    end
  end
end
