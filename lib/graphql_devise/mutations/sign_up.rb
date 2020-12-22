# frozen_string_literal: true

module GraphqlDevise
  module Mutations
    class SignUp < Base
      argument :email,                 String, required: true
      argument :password,              String, required: true
      argument :password_confirmation, String, required: true
      argument :confirm_success_url,   String, required: false

      field :credentials,
            GraphqlDevise::Types::CredentialType,
            null:        true,
            description: 'Authentication credentials. Null if after signUp resource is not active for authentication (e.g. Email confirmation required).'

      def resolve(confirm_success_url: nil, **attrs)
        resource = build_resource(attrs.merge(provider: provider))
        raise_user_error(I18n.t('graphql_devise.resource_build_failed')) if resource.blank?

        redirect_url = confirm_success_url || DeviseTokenAuth.default_confirm_success_url
        if confirmable_enabled? && redirect_url.blank?
          raise_user_error(I18n.t('graphql_devise.registrations.missing_confirm_redirect_url'))
        end

        check_redirect_url_whitelist!(redirect_url)

        resource.skip_confirmation_notification! if resource.respond_to?(:skip_confirmation_notification!)

        if resource.save
          yield resource if block_given?

          unless resource.confirmed?
            resource.send_confirmation_instructions(
              redirect_url:  confirm_success_url,
              template_path: ['graphql_devise/mailer'],
              schema_url:    controller.full_url_without_params
            )
          end

          response_payload = { authenticatable: resource }

          response_payload[:credentials] = set_auth_headers(resource) if resource.active_for_authentication?

          response_payload
        else
          resource.try(:clean_up_passwords)
          raise_user_error_list(
            I18n.t('graphql_devise.registration_failed'),
            errors: resource.errors.full_messages
          )
        end
      end

      private

      def build_resource(attrs)
        resource_class.new(attrs)
      end
    end
  end
end
