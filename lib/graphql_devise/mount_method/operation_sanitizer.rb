# frozen_string_literal: true

module GraphqlDevise
  module MountMethod
    class OperationSanitizer
      def self.call(default:, only:, skipped:, allow_destroy: false)
        new(
          default:       default,
          only:          only,
          skipped:       skipped,
          allow_destroy: allow_destroy
        ).call
      end

      def initialize(default:, only:, skipped:, allow_destroy: false)
        @default       = default
        @only          = only
        @skipped       = skipped
        @allow_destroy = allow_destroy
      end

      def call
        # When `only` is provided the list is explicit, so `allow_destroy` operations are included
        # (and never warned about) whenever they are named in it.
        return @default.slice(*@only) if @only.present?

        selected = @skipped.present? ? @default.except(*@skipped) : @default

        reject_allow_destroy(selected)
      end

      private

      def reject_allow_destroy(operations)
        return operations if @allow_destroy

        operations.reject do |name, options|
          next false unless requires_allow_destroy?(options)

          warn_excluded(name)
          true
        end
      end

      def requires_allow_destroy?(options)
        options.is_a?(Hash) && options[:allow_destroy]
      end

      def warn_excluded(name)
        ::Rails.logger&.warn(
          "[graphql_devise] The `#{name}` operation is not mounted because it is opt-in. " \
          "Pass `allow_destroy: true` (or add it to the `only:` option) to include it. " \
          "To keep it out and silence this warning, add `#{name}` to the `skip:` option."
        )
      end
    end
  end
end
