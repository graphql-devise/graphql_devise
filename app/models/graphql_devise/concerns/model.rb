# frozen_string_literal: true

require 'graphql_devise/model/with_email_updater'

module GraphqlDevise
  module Concerns
    module Model
      extend ActiveSupport::Concern

      included do
        include DeviseTokenAuth::Concerns::User
        include GraphqlDevise::Concerns::AdditionalModelMethods

        GraphqlDevise.configure_warden_serializer_for_model(self)

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
