# frozen_string_literal: true

module GraphqlDevise
  module MountMethod
    class OperationSanitizer
      def self.call(default:, only:, skipped:)
        new(
          default: default,
          only:    only,
          skipped: skipped
        ).call
      end

      def initialize(default:, only:, skipped:)
        @default = default
        @only    = only
        @skipped = skipped
      end

      def call
        if @only.present?
          @default.slice(*@only)
        elsif @skipped.present?
          @default.except(*@skipped)
        else
          @default
        end
      end
    end
  end
end
