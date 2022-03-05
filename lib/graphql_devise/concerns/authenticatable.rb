# frozen_string_literal: true

module GraphqlDevise
  module Authenticatable
    extend ActiveSupport::Concern

    included do
      include DeviseTokenAuth::Concerns::User

      ::GraphqlDevise.configure_warden_serializer_for_model(self)
    end

    class_methods do
      def reconfirmable
        devise_modules.include?(:confirmable) && column_names.include?('unconfirmed_email')
      end
    end

    def update_with_email(attributes = {})
      Model::WithEmailUpdater.new(self, attributes).call
    end
  end
end
