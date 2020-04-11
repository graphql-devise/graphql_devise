module GraphqlDevise
  module MountMethod
    module OperationPreparers
      class DefaultOperationPreparer
        def initialize(selected_operations:, custom_keys:, mapping_name:, preparer:)
          @selected_operations = selected_operations
          @custom_keys         = custom_keys
          @mapping_name        = mapping_name
          @preparer            = preparer
        end

        def call
          @selected_operations.except(*@custom_keys).each_with_object({}) do |(action, operation), result|
            mapped_action = "#{@mapping_name}_#{action}"

            result[mapped_action.to_sym] = [
              OperationPreparers::GqlNameSetter.new(mapped_action),
              @preparer,
              OperationPreparers::ResourceNameSetter.new(@mapping_name)
            ].reduce(child_class(operation)) { |prepared_operation, preparer| preparer.call(prepared_operation) }
          end
        end

        private

        def child_class(operation)
          Class.new(operation)
        end
      end
    end
  end
end
