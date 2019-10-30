module GraphqlDevise
  module Mutations
    class ResendConfirmation < Base
      argument :email,        String, required: true, prepare: ->(email, _) { email.downcase }
      argument :redirect_url, String, required: true
      
      field :success, Boolean, null: false
      field :message, String, null: false
      
      def resolve(email:, redirect_url:)
        resource = controller.find_resource(:uid, email)

        if resource
          yield resource if block_given?
          resource.send_confirmation_instructions({
            redirect_url: redirect_url,
            template_path: ['graphql_devise/mailer']
          })

          {
            success: true,
            message: I18n.t('graphql_devise.confirmations.send_instructions', email: email)
          }
        else
          raise_user_error(I18n.t('graphql_devise.confirmations.user_not_found', email: email))
        end
      end
    end
  end
end
