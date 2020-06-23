# frozen_string_literal: true

module GraphqlDevise
  module MountMethod
    module OperationPreparers
      class ResolverTypeSetter
        def initialize(authenticatable_type)
          @authenticatable_type = authenticatable_type
        end

        def call(resolver, **)
          resolver.type(@authenticatable_type, null: false)

          resolver
        end
      end
    end
  end
end
