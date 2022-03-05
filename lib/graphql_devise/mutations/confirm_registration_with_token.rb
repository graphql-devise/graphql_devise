# frozen_string_literal: true

module GraphqlDevise
  module Mutations
    class ConfirmRegistrationWithToken < Base
      argument :confirmation_token, String, required: true

      field :credentials,
            Types::CredentialType,
            null:        true,
            description: 'Authentication credentials. Null unless user is signed in after confirmation.'

      def resolve(confirmation_token:)
        resource = resource_class.confirm_by_token(confirmation_token)

        if resource.errors.empty?
          yield resource if block_given?

          response_payload = { authenticatable: resource }

          response_payload[:credentials] = set_auth_headers(resource) if resource.active_for_authentication?

          response_payload
        else
          raise_user_error(I18n.t('graphql_devise.confirmations.invalid_token'))
        end
      end
    end
  end
end
