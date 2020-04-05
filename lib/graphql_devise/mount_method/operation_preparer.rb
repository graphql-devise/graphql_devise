require_relative 'operation_preparers/default_operation_creator'
require_relative 'operation_preparers/mutation_field_setter'
require_relative 'operation_preparers/resolver_type_setter'
require_relative 'operation_preparers/resource_name_setter'

module GraphqlDevise
  module MountMethod
    class OperationPreparer
      def initialize(resource:, selected_operations:, preparer:, custom:, additional_operations:)
        @selected_operations  = selected_operations
        @preparer             = preparer
        @mapping_name         = resource.underscore.tr('/', '_')
        @custom               = custom
        @additional_operations = additional_operations
      end

      def call
        default_operations = @selected_operations.except(*@custom.keys).each_with_object({}) do |(action, operation), result|
          mapped_action = "#{@mapping_name}_#{action}"

          prepared_operation = OperationPreparers::DefaultOperationCreator.new(operation, mapped_action.to_s.camelize(:upper)).call
          prepared_operation = @preparer.call(prepared_operation)
          prepared_operation = OperationPreparers::ResourceNameSetter.new(prepared_operation, @mapping_name).call

          result[mapped_action.to_sym] = prepared_operation
        end

        custom_operations = @custom.slice(*@selected_operations.keys).each_with_object({}) do |(action, operation), result|
          mapped_action = "#{@mapping_name}_#{action}"

          result[mapped_action.to_sym] = OperationPreparers::ResourceNameSetter.new(operation, @mapping_name).call
        end

        additional_operations = @additional_operations.each_with_object({}) do |(action, operation), result|
          result[action] = OperationPreparers::ResourceNameSetter.new(operation, @mapping_name).call
        end

        default_operations.merge(custom_operations).merge(additional_operations)
      end
    end
  end
end
