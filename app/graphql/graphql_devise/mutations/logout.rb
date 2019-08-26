module GraphqlDevise
  module Mutations
    class Logout < Base
      field :success, Boolean,  null: false
      field :errors,  [String], null: false

      def resolve
        client = token.client if token.client

        if current_user && token.client && current_user.tokens[client]
          user.tokens.delete(client)
          user.save!

          yield user if block_given?

          { success: true, errors: [] }
        else
          { success: false, errors: [I18n.t('graphql_devise.user_not_found')] }
        end
      end
    end
  end
end
