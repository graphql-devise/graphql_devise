# frozen_string_literal: true

module GraphqlDevise
  module MountMethod
    module OptionValidators
      class SupportedOperationsValidator
        def initialize(provided_operations: [], supported_operations: [], key:)
          @provided_operations  = provided_operations
          @supported_operations = supported_operations
          @key                  = key
        end

        def validate!
          unsupported_operations = @provided_operations - @supported_operations

          if unsupported_operations.present?
            raise(
              GraphqlDevise::InvalidMountOptionsError,
              "#{@key} option contains unsupported operations: \"#{unsupported_operations.join(', ')}\". Check for typos."
            )
          end
        end
      end
    end
  end
end
