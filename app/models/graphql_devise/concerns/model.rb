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
      end
    end
  end
end
