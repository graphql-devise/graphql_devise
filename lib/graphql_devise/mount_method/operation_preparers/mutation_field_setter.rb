# frozen_string_literal: true

module GraphqlDevise
  module MountMethod
    module OperationPreparers
      class MutationFieldSetter
        def initialize(authenticatable_type)
          @authenticatable_type = authenticatable_type
        end

        def call(mutation, authenticatable: true)
          return mutation unless authenticatable

          mutation.field(:authenticatable, @authenticatable_type, null: false)
          mutation
        end
      end
    end
  end
end
