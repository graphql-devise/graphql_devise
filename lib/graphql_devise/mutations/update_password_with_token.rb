# frozen_string_literal: true

module GraphqlDevise
  module Mutations
    class UpdatePasswordWithToken < Base
      argument :password,              String, required: true
      argument :password_confirmation, String, required: true
      argument :reset_password_token,  String, required: true

      field :credentials,
            GraphqlDevise::Types::CredentialType,
            null:        true,
            description: 'Authentication credentials. Resource must be signed_in for credentials to be returned.'

      def resolve(reset_password_token:, **attrs)
        raise_user_error(I18n.t('graphql_devise.passwords.password_recovery_disabled')) unless recoverable_enabled?

        resource = resource_class.with_reset_password_token(reset_password_token)
        raise_user_error(I18n.t('graphql_devise.passwords.reset_token_not_found')) if resource.blank?
        raise_user_error(I18n.t('graphql_devise.passwords.reset_token_expired')) unless resource.reset_password_period_valid?

        if resource.update(attrs)
          yield resource if block_given?

          response_payload               = { authenticatable: resource }
          response_payload[:credentials] = set_auth_headers(resource) if controller.signed_in?(resource_name)

          response_payload
        else
          raise_user_error_list(
            I18n.t('graphql_devise.passwords.update_password_error'),
            errors: resource.errors.full_messages
          )
        end
      end
    end
  end
end
