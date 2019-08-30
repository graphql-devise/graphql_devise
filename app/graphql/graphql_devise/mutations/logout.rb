module GraphqlDevise
  module Mutations
    class Logout < Base
      field :success, Boolean,  null: false
      field :errors,  [String], null: false

      def resolve
        if current_resource && client && current_resource.tokens[client]
          current_resource.tokens.delete(client)
          current_resource.save!

          remove_resource

          yield current_resource if block_given?

          { success: true, errors: [], authenticable: current_resource }
        else
          { success: false, errors: [I18n.t('graphql_devise.user_not_found')] }
        end
      end
    end
  end
end
