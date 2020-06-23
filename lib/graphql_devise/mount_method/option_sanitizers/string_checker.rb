# frozen_string_literal: true

module GraphqlDevise
  module MountMethod
    module OptionSanitizers
      class StringChecker
        def initialize(default_string = nil)
          @default_string = default_string
        end

        def call!(value, key)
          return @default_string if value.blank?

          unless value.instance_of?(String)
            raise GraphqlDevise::InvalidMountOptionsError, "`#{key}` option has an invalid value. String expected."
          end

          value
        end
      end
    end
  end
end
