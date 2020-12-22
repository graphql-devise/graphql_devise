# frozen_string_literal: true

module GraphqlDevise
  module Mutations
    class SendPasswordReset < Base
      argument :email,        String, required: true
      argument :redirect_url, String, required: true

      field :message, String, null: false

      def resolve(email:, redirect_url:)
        check_redirect_url_whitelist!(redirect_url)

        resource = find_resource(:email, get_case_insensitive_field(:email, email))

        if resource
          yield resource if block_given?

          resource.send_reset_password_instructions(
            email:         email,
            provider:      'email',
            redirect_url:  redirect_url,
            template_path: ['graphql_devise/mailer'],
            schema_url:    controller.full_url_without_params
          )

          if resource.errors.empty?
            { message: I18n.t('graphql_devise.passwords.send_instructions') }
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
