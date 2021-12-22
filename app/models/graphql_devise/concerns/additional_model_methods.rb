# frozen_string_literal: true

require 'graphql_devise/model/with_email_updater'

module GraphqlDevise
  module Concerns
    module AdditionalModelMethods
      extend ActiveSupport::Concern

      class_methods do
        def reconfirmable
          devise_modules.include?(:confirmable) && column_names.include?('unconfirmed_email')
        end
      end

      def update_with_email(attributes = {})
        GraphqlDevise::Model::WithEmailUpdater.new(self, attributes).call
      end

      def send_confirmation_email(redirect_url)
        token = set_reset_password_token
        GraphqlDevise::Mailer.confirmation_instructions(self, token, redirect_url).deliver

        token
      end
    end
  end
end
