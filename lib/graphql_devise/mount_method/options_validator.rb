# frozen_string_literal: true

require_relative 'option_validators/skip_only_validator'
require_relative 'option_validators/provided_operations_validator'

module GraphqlDevise
  module MountMethod
    class OptionsValidator
      def initialize(validators = [])
        @validators = validators
      end

      def validate!
        @validators.each(&:validate!)
      end
    end
  end
end
