require 'graphql_devise/model/with_email_updater'

module GraphqlDevise
  module Concerns
    Model = DeviseTokenAuth::Concerns::User

    Model.module_eval do
      def update_with_email(attributes = {})
        GraphqlDevise::Model::WithEmailUpdater.new(self, attributes).call
      end
    end
  end
end
