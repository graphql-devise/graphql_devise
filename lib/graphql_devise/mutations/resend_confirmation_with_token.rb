# frozen_string_literal: true

module GraphqlDevise
  module Mutations
    class ResendConfirmationWithToken < Base
      argument :email,       String, required: true
      argument :confirm_url, String, required: true

      field :message, String, null: false

      def resolve(email:, confirm_url:)
        check_redirect_url_whitelist!(confirm_url)

        resource = find_confirmable_resource(email)

        if resource
          yield resource if block_given?

          if resource.confirmed? && !resource.pending_reconfirmation?
            raise_user_error(I18n.t('graphql_devise.confirmations.already_confirmed'))
          end

          resource.send_confirmation_instructions(
            redirect_url:  confirm_url,
            template_path: ['graphql_devise/mailer']
          )

          { message: I18n.t('graphql_devise.confirmations.send_instructions', email: email) }
        else
          raise_user_error(I18n.t('graphql_devise.confirmations.user_not_found', email: email))
        end
      end

      private

      def find_confirmable_resource(email)
        email_insensitive = get_case_insensitive_field(:email, email)
        resource = find_resource(:unconfirmed_email, email_insensitive) if resource_class.reconfirmable
        resource ||= find_resource(:email, email_insensitive)
        resource
      end
    end
  end
end
