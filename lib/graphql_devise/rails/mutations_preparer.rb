module GraphqlDevise
  class MutationsPreparer
    DEFAULT_MUTATIONS = {
      login:               GraphqlDevise::Mutations::Login,
      logout:              GraphqlDevise::Mutations::Logout,
      sign_up:             GraphqlDevise::Mutations::SignUp,
      update_password:     GraphqlDevise::Mutations::UpdatePassword,
      send_password_reset: GraphqlDevise::Mutations::SendPasswordReset,
      resend_confirmation: GraphqlDevise::Mutations::ResendConfirmation
    }.freeze

    def self.call(resource:, mutations:, authenticatable_type:)
      new(resource: resource, mutations: mutations, authenticatable_type: authenticatable_type).call
    end

    def initialize(resource:, mutations:, authenticatable_type:)
      @mapping_name         = resource.underscore.tr('/', '_').to_sym
      @mutations            = mutations
      @authenticatable_type = authenticatable_type
    end

    def call
      @mutations.each_with_object({}) do |(action, mutation), result|
        mapped_action = "#{@mapping_name}_#{action}".to_sym
        new_mutation  = Class.new(mutation)
        new_mutation.graphql_name(mapped_action.to_s.camelize(:upper))
        new_mutation.field(:authenticatable, @authenticatable_type, null: true)
        new_mutation.instance_variable_set(:@resource_name, @mapping_name)

        result[mapped_action] = new_mutation
      end
    end
  end
end
