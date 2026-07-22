# frozen_string_literal: true

module GraphqlDevise
  module Mutations
    class DestroyAccount < Base
      def resolve
        raise_user_error(I18n.t('graphql_devise.user_not_found')) unless current_resource

        if current_resource.destroy
          # Clear the controller resource/token so devise_token_auth's `update_auth_header`
          # after_action doesn't try to reload the now deleted record.
          remove_resource

          yield current_resource if block_given?

          { authenticatable: current_resource }
        else
          raise_user_error_list(
            I18n.t('graphql_devise.destroy_account_failed'),
            resource: current_resource
          )
        end
      end
    end
  end
end
