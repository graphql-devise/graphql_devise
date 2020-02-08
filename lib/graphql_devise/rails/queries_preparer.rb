module GraphqlDevise
  class QueriesPreparer
    def self.call(resource:, queries:, authenticatable_type:)
      new(resource: resource, queries: queries, authenticatable_type: authenticatable_type).call
    end

    def initialize(resource:, queries:, authenticatable_type:)
      @mapping_name         = resource.underscore.tr('/', '_').to_sym
      @queries              = queries
      @authenticatable_type = authenticatable_type
    end

    def call
      result = {}

      @queries.each do |action, query|
        mapped_action = "#{@mapping_name}_#{action}".to_sym
        new_query     = Class.new(query)
        new_query.graphql_name(mapped_action.to_s.camelize(:upper))
        new_query.type(@authenticatable_type, null: true)
        new_query.instance_variable_set(:@resource_name, @mapping_name)

        result[mapped_action] = new_query
      end

      result
    end
  end
end
