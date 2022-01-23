# frozen_string_literal: true

module GraphqlDevise
  module MountMethod
    class OptionSanitizer
      def initialize(options = {}, supported_options = MountMethod::SUPPORTED_OPTIONS)
        @options           = options
        @supported_options = supported_options
      end

      def call!
        @supported_options.each_with_object(Struct.new(*@supported_options.keys).new) do |(key, checker), result|
          result[key] = checker.call!(@options[key], key)
        end
      end
    end
  end
end
