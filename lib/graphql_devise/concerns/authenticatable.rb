# frozen_string_literal: true

module GraphqlDevise
  module Authenticatable
    extend ActiveSupport::Concern

    included do
      include DeviseTokenAuth::Concerns::User
      include AdditionalModelMethods

      ::GraphqlDevise.configure_warden_serializer_for_model(self)
    end
  end
end
