module GraphqlDevise
  class OperationSanitizer
    def self.call(default:, custom:, only:, skipped:)
      new(
        default: default,
        custom:  custom,
        only:    only,
        skipped: skipped
      ).call
    end

    def initialize(default:, custom:, only:, skipped:)
      @default = default
      @custom  = custom
      @only    = only
      @skipped = skipped
    end

    def call
      result = @default
      result = result.merge(@custom.slice(*operations_whitelist))
      result = result.slice(*@only) if @only.present?
      result = result.except(*@skipped) if @skipped.present?

      result
    end

    private

    def operations_whitelist
      @default.keys
    end
  end
end
