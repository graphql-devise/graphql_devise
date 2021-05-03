# frozen_string_literal: true

module GraphqlDevise
  module MountMethod
    module OperationPreparers
      class ResourceKlassSetter
        def initialize(klass)
          @klass = klass
        end

        def call(operation, **)
          operation.instance_variable_set(:@resource_klass, @klass)

          operation
        end
      end
    end
  end
end
