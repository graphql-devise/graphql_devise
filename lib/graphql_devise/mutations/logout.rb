# frozen_string_literal: true

module GraphqlDevise
  module Mutations
    class Logout < Base
      def resolve
        if current_resource && client && current_resource.tokens[client]
          current_resource.tokens.delete(client)
          current_resource.save!

          remove_resource

          yield current_resource if block_given?

          { authenticatable: current_resource }
        else
          raise_user_error(I18n.t('graphql_devise.user_not_found'))
        end
      end
    end
  end
end
