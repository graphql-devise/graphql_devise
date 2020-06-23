# frozen_string_literal: true

module GraphqlDevise
  module MountMethod
    module OptionValidators
      class SkipOnlyValidator
        def initialize(options:)
          @options = options
        end

        def validate!
          if [@options.skip, @options.only].all?(&:present?)
            raise(
              GraphqlDevise::InvalidMountOptionsError,
              "Can't specify both `skip` and `only` options when mounting the route."
            )
          end
        end
      end
    end
  end
end
