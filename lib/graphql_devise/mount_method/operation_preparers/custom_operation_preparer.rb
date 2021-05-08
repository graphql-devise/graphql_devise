# frozen_string_literal: true

module GraphqlDevise
  module MountMethod
    module OperationPreparers
      class CustomOperationPreparer
        def initialize(selected_keys:, custom_operations:, model:)
          @selected_keys     = selected_keys
          @custom_operations = custom_operations
          @model             = model
        end

        def call
          mapping_name = GraphqlDevise.to_mapping_name(@model)

          @custom_operations.slice(*@selected_keys).each_with_object({}) do |(action, operation), result|
            mapped_action = "#{mapping_name}_#{action}"

            result[mapped_action.to_sym] = [
              OperationPreparers::GqlNameSetter.new(mapped_action),
              OperationPreparers::ResourceKlassSetter.new(@model)
            ].reduce(operation) { |prepared_operation, preparer| preparer.call(prepared_operation) }
          end
        end
      end
    end
  end
end
