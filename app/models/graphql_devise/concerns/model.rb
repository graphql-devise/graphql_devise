# frozen_string_literal: true

require 'graphql_devise/model/with_email_updater'

module GraphqlDevise
  module Concerns
    Model = DeviseTokenAuth::Concerns::User

    Model.module_eval do
      class_methods do
        def reconfirmable
          devise_modules.include?(:confirmable) && column_names.include?('unconfirmed_email')
        end
      end

      def update_with_email(attributes = {})
        GraphqlDevise::Model::WithEmailUpdater.new(self, attributes).call
      end
    end
  end
end
