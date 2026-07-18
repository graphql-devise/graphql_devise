# frozen_string_literal: true

module GraphqlDevise
  module MountMethod
    module OptionSanitizers
      class BooleanChecker
        def initialize(default_boolean = nil)
          @default_boolean = default_boolean
        end

        def call!(value, key)
          return @default_boolean if value.nil?

          unless value.instance_of?(TrueClass) || value.instance_of?(FalseClass)
            raise InvalidMountOptionsError, "`#{key}` option has an invalid value. `true` or `false` expected."
          end

          value
        end
      end
    end
  end
end
