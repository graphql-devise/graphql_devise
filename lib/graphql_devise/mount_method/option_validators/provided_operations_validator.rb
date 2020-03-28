require_relative 'supported_operations_validator'

module GraphqlDevise
  module MountMethod
    module OptionValidators
      class ProvidedOperationsValidator
        def initialize(options: {}, supported_operations: {})
          @options              = options || {}
          @supported_operations = supported_operations
        end

        def validate!
          skipped        = @options.fetch(:skip, [])
          only           = @options.fetch(:only, [])
          operations     = @options.fetch(:operations, {})
          supported_keys = @supported_operations.keys

          raise_on_invalid_option_type!(:skip, skipped, Array)
          raise_on_invalid_option_type!(:only, only, Array)
          raise_on_invalid_option_type!(:operations, operations, Hash)

          custom = operations.keys

          [
            SupportedOperationsValidator.new(provided_operations: skipped, key: :skip, supported_operations: supported_keys),
            SupportedOperationsValidator.new(provided_operations: only, key: :only, supported_operations: supported_keys),
            SupportedOperationsValidator.new(provided_operations: custom, key: :operations, supported_operations: supported_keys)
          ].each(&:validate!)
        end

        private

        def raise_on_invalid_option_type!(key, value, expected_class)
          unless value.is_a?(expected_class)
            raise(
              GraphqlDevise::InvalidMountOptionsError,
              "#{key} option contains value of invalid value. Value must be #{expected_class.name}."
            )
          end
        end
      end
    end
  end
end
