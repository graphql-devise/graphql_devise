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
        operations = if @only.present?
          @default.slice(*@only)
        elsif @skipped.present?
          @default.except(*@skipped)
        else
          @default
        end

        operations.each do |operation, values|
          next if values[:deprecation_reason].blank?

          ActiveSupport::Deprecation.warn(<<-DEPRECATION.strip_heredoc, caller)
              `#{operation}` is deprecated and will be removed in a future version of this gem.
              #{values[:deprecation_reason]}

              You can supress this message by skipping `#{operation}` on your ResourceLoader or the
              mount_graphql_devise_for method on your routes file.
          DEPRECATION
        end
      end
    end
  end
end
