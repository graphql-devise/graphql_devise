# frozen_string_literal: true

require_relative 'supported_operations_validator'

module GraphqlDevise
  module MountMethod
    module OptionValidators
      class ProvidedOperationsValidator
        def initialize(options:, supported_operations:)
          @options              = options
          @supported_operations = supported_operations
        end

        def validate!
          supported_keys = @supported_operations.keys

          [
            SupportedOperationsValidator.new(provided_operations: @options.skip, key: :skip, supported_operations: supported_keys),
            SupportedOperationsValidator.new(provided_operations: @options.only, key: :only, supported_operations: supported_keys),
            SupportedOperationsValidator.new(provided_operations: @options.operations.keys, key: :operations, supported_operations: supported_keys)
          ].each(&:validate!)
        end
      end
    end
  end
end
