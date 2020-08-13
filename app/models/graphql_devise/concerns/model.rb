# frozen_string_literal: true

require 'graphql_devise/model/with_email_updater'

module GraphqlDevise
  module Concerns
    Model = DeviseTokenAuth::Concerns::User

    Model.module_eval do
      def update_with_email(attributes = {})
        GraphqlDevise::Model::WithEmailUpdater.new(self, attributes).call
      end

      private

      def pending_reconfirmation?
        devise_modules.include?(:confirmable) && try(:unconfirmed_email).present?
      end
    end
  end
end
