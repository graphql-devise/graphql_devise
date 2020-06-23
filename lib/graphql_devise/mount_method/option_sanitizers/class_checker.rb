# frozen_string_literal: true

module GraphqlDevise
  module MountMethod
    module OptionSanitizers
      class ClassChecker
        def initialize(klass)
          @klass_array = Array(klass)
        end

        def call!(value, key)
          return if value.nil?

          unless value.instance_of?(Class)
            raise GraphqlDevise::InvalidMountOptionsError, "`#{key}` option has an invalid value. Class expected."
          end

          unless @klass_array.any? { |klass| value.ancestors.include?(klass) }
            raise GraphqlDevise::InvalidMountOptionsError,
                  "`#{key}` option has an invalid value. #{@klass_array.join(', ')} or descendants expected. Got #{value}."
          end

          value
        end
      end
    end
  end
end
