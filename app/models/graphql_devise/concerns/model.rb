# frozen_string_literal: true

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
