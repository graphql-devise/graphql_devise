# frozen_string_literal: true

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

          value.each { |internal_key, klass| ClassChecker.new(@element_type_array).call!(klass, "#{key} -> #{internal_key}") }

          value
        end
      end
    end
  end
end
