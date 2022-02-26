# frozen_string_literal: true

module GraphqlDevise
  module Concerns
    module SetUserByToken
      extend ActiveSupport::Concern

      included do
        include ::GraphqlDevise::SetUserByToken

        ActiveSupport::Deprecation.warn(<<-DEPRECATION.strip_heredoc, caller)
          Including GraphqlDevise::Concerns::SetUserByToken is deprecated and will be removed in a future version of
          this gem. Please use GraphqlDevise::SetUserByToken instead.

          EXAMPLE

          include GraphqlDevise::SetUserByToken
        DEPRECATION
      end
    end
  end
end
