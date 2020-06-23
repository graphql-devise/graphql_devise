# frozen_string_literal: true

module GraphqlDevise
  module MountMethod
    module OptionSanitizers
      class ArrayChecker
        def initialize(element_type)
          @element_type  = element_type
          @default_value = []
        end

        def call!(value, key)
          return @default_value if value.blank?

          unless value.instance_of?(Array)
            raise GraphqlDevise::InvalidMountOptionsError, "`#{key}` option has an invalid value. Array expected."
          end

          unless value.all? { |element| element.instance_of?(@element_type) }
            raise GraphqlDevise::InvalidMountOptionsError, "`#{key}` option has invalid elements. #{@element_type} expected."
          end

          value
        end
      end
    end
  end
end
