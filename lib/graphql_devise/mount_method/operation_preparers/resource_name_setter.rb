module GraphqlDevise
  module MountMethod
    module OperationPreparers
      class ResourceNameSetter
        def initialize(name)
          @name = name
        end

        def call(operation)
          operation.instance_variable_set(:@resource_name, @name.to_sym)

          operation
        end
      end
    end
  end
end
