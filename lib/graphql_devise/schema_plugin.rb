module GraphqlDevise
  class SchemaPlugin
    def initialize(query:, mutation: nil, resource_loaders: [])
      @query            = query
      @mutation         = mutation
      @resource_loaders = resource_loaders

      # Must happen on initialize so operations are loaded before the types are added to the schema on GQL < 1.10
      load_fields
    end

    private

    def load_fields
      @resource_loaders.each do |resource_loader|
        raise Error, 'Invalid resource loader instance' unless resource_loader.instance_of?(GraphqlDevise::ResourceLoader)

        resource_loader.call(@query, @mutation, false)
      end
    end
  end
end
