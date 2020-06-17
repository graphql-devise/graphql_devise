module GraphqlDevise
  module Mutations
    class ResendConfirmation < Base
      argument :email,        String, required: true, prepare: ->(email, _) { email.downcase }
      argument :redirect_url, String, required: true

      field :message, String, null: false

      def resolve(email:, redirect_url:)
        resource = find_resource(
          :email,
          get_case_insensitive_field(:email, email)
        )

        if resource
          yield resource if block_given?

          raise_user_error(I18n.t('graphql_devise.confirmations.already_confirmed')) if resource.confirmed?

          resource.send_confirmation_instructions(
            redirect_url:  redirect_url,
            template_path: ['graphql_devise/mailer'],
            **controller.params.permit('controller', 'action').to_h.symbolize_keys
          )

          { message: I18n.t('graphql_devise.confirmations.send_instructions', email: email) }
        else
          raise_user_error(I18n.t('graphql_devise.confirmations.user_not_found', email: email))
        end
      end
    end
  end
end
