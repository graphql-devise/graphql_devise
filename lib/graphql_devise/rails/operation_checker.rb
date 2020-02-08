module GraphqlDevise
  class OperationChecker
    def self.call(mutations:, queries:, custom:, only:, skipped:)
      new(
        mutations: mutations,
        queries:   queries,
        custom:    custom,
        only:      only,
        skipped:   skipped
      ).call
    end

    def initialize(mutations:, queries:, custom:, only:, skipped:)
      @mutations = mutations
      @queries   = queries
      @custom    = custom
      @only      = only
      @skipped   = skipped
    end

    def call
      supported_operations = @mutations.keys + @queries.keys

      if [@skipped, @only].all?(&:any?)
        raise GraphqlDevise::Error, "Can't specify both `skip` and `only` options when mounting the route."
      end

      unless @custom.keys.all? { |custom_op| supported_operations.include?(custom_op) }
        raise GraphqlDevise::Error, 'One of the custom operations is not supported. Check for typos.'
      end
      unless @skipped.all? { |skipped_op| supported_operations.include?(skipped_op) }
        raise GraphqlDevise::Error, 'Trying to skip a non supported operation. Check for typos.'
      end
      unless @only.all? { |only_op| supported_operations.include?(only_op) }
        raise GraphqlDevise::Error, 'One of the `only` operations is not supported. Check for typos.'
      end
    end
  end
end
