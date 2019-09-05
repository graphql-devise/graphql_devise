module GraphqlDevise
  module Mutations
    class Login < Base
      argument :email,    String, required: true
      argument :password, String, required: true

      def resolve(email:, password:)
        resource = resource_class.find_by(email: email)

        if resource && active_for_authentication?(resource)
          if invalid_for_authentication?(resource, password)
            raise_user_error(I18n.t('graphql_devise.sessions.bad_credentials'))
          end

          set_auth_headers(resource)
          controller.sign_in(:user, resource, store: false, bypass: false)

          yield resource if block_given?

          { authenticable: resource}
        elsif resource && !active_for_authentication?(resource)
          if locked?(resource)
            raise_user_error(I18n.t('graphql_devise.mailer.unlock_instructions.account_lock_msg'))
          else
            raise_user_error(I18n.t('devise_token_auth.sessions.not_confirmed', email: resource.email))
          end
        else
          raise_user_error(I18n.t('graphql_devise.sessions.bad_credentials'))
        end
      end

      private

      def invalid_for_authentication?(resource, password)
        valid_password = resource.valid_password?(password)

        (resource.respond_to?(:valid_for_authentication?) && !resource.valid_for_authentication? { valid_password }) ||
          !valid_password
      end

      def active_for_authentication?(resource)
        !resource.respond_to?(:active_for_authentication?) || resource.active_for_authentication?
      end

      def locked?(resource)
        resource.respond_to?(:locked_at) && resource.locked_at
      end
    end
  end
end
