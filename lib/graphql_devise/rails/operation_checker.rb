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
        raise(
          GraphqlDevise::Error,
          "Can't specify both `skip` and `only` options when mounting the route."
        )
      end

      @custom.keys.each do |custom_op|
        next if supported_operations.include?(custom_op)

        raise(
          GraphqlDevise::Error,
          "Custom operation \"#{custom_op}\" is not supported. Check for typos."
        )
      end

      @skipped.each do |skipped_op|
        next if supported_operations.include?(skipped_op)

        raise(
          GraphqlDevise::Error,
          "Trying to skip unsupported operation \"#{skipped_op}\". Check for typos."
        )
      end

      @only.each do |only_op|
        next if supported_operations.include?(only_op)

        raise(
          GraphqlDevise::Error,
          "The \"only\" operation \"#{only_op}\" is not supported. Check for typos."
        )
      end
    end
  end
end
