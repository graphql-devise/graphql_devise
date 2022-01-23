# frozen_string_literal: true

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
