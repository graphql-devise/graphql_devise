module GraphqlDevise
  class MutationsPreparer
    def self.call(resource:, mutations:, authenticatable_type:)
      new(resource: resource, mutations: mutations, authenticatable_type: authenticatable_type).call
    end

    def initialize(resource:, mutations:, authenticatable_type:)
      @mapping_name         = resource.underscore.tr('/', '_').to_sym
      @mutations            = mutations
      @authenticatable_type = authenticatable_type
    end

    def call
      result = {}

      @mutations.each do |action, mutation|
        mapped_action = "#{@mapping_name}_#{action}".to_sym
        new_mutation  = Class.new(mutation)
        new_mutation.graphql_name(mapped_action.to_s.camelize(:upper))
        new_mutation.field(:authenticatable, @authenticatable_type, null: true)
        new_mutation.instance_variable_set(:@resource_name, @mapping_name)

        result[mapped_action] = new_mutation
      end

      result
    end
  end
end
