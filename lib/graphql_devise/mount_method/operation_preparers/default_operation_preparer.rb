# frozen_string_literal: true

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
          @selected_operations.except(*@custom_keys).each_with_object({}) do |(action, operation_info), result|
            mapped_action = "#{@mapping_name}_#{action}"
            operation     = operation_info[:klass]
            options       = operation_info.except(:klass)

            result[mapped_action.to_sym] = [
              OperationPreparers::GqlNameSetter.new(mapped_action),
              @preparer,
              OperationPreparers::ResourceNameSetter.new(@mapping_name)
            ].reduce(child_class(operation)) do |prepared_operation, preparer|
              preparer.call(prepared_operation, **options)
            end
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
