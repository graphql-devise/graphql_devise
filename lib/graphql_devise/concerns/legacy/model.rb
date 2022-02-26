# frozen_string_literal: true

module GraphqlDevise
  module Concerns
    module Model
      extend ActiveSupport::Concern

      included do
        include Authenticatable

        ActiveSupport::Deprecation.warn(<<-DEPRECATION.strip_heredoc, caller)
          Including GraphqlDevise::Concerns::Model is deprecated and will be removed in a future version of
          this gem. Please use GraphqlDevise::Authenticatable instead.

          EXAMPLE

          include GraphqlDevise::Authenticatable
        DEPRECATION
      end
    end
  end
end
