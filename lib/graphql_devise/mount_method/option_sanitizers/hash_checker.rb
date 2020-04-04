module GraphqlDevise
  module MountMethod
    module OptionSanitizers
      class HashChecker
        def initialize(element_type_array)
          @element_type_array = Array(element_type_array)
          @default_value      = {}
        end

        def call!(value, key)
          return @default_value if value.blank?

          unless value.instance_of?(Hash)
            raise GraphqlDevise::InvalidMountOptionsError, "`#{key}` option has an invalid value. Hash expected. Got #{value.class}."
          end

          unless value.all? { |_, element| element.instance_of?(Class) && @element_type_array.any? { |type| element.ancestors.include?(type) } }
            raise GraphqlDevise::InvalidMountOptionsError, "`#{key}` option has invalid elements. [#{@element_type_array.join(', ')}] or descendants expected. Got #{value}."
          end

          value
        end
      end
    end
  end
end
