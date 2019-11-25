module GraphqlDevise
  module Mutations
    class SendPasswordReset < Base
      argument :email,        String, required: true, prepare: ->(email, _) { email.downcase }
      argument :redirect_url, String, required: true

      def resolve(email:, redirect_url:)
        resource = controller.find_resource(:uid, email)

        if resource
          yield resource if block_given?
          resource.send_reset_password_instructions(
            email:         email,
            provider:      'email',
            redirect_url:  redirect_url,
            template_path: ['graphql_devise/mailer']
          )

          if resource.errors.empty?
            { authenticatable: resource }
          else
            raise_user_error_list(I18n.t('graphql_devise.invalid_resource'), errors: resource.errors.full_messages)
          end
        else
          raise_user_error(I18n.t('graphql_devise.user_not_found'))
        end
      end
    end
  end
end
