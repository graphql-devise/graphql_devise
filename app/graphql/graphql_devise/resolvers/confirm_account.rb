module GraphqlDevise
  module Resolvers
    class ConfirmAccount < Base
      argument :confirmation_token, String, required: true
      argument :redirect_url,       String, required: true

      def resolve(confirmation_token:, redirect_url:)
        resource = resource_class.confirm_by_token(confirmation_token)

        if resource.errors.empty?
          yield resource if block_given?

          redirect_header_options = { account_confirmation_success: true }

          redirect_to_link = if controller.signed_in?(resource_name)
            signed_in_resource.build_auth_url(
              redirect_url,
              redirect_headers(
                client_and_token(controller.signed_in_resource.create_token),
                redirect_header_options
              )
            )
          else
            DeviseTokenAuth::Url.generate(redirect_url, redirect_header_options)
          end

          controller.redirect_to(redirect_to_link)
          { authenticable: resource }
        else
          raise_user_error(I18n.t('graphql_devise.confirmations.invalid_token'))
        end
      end

      private

      def resource_name
        resource_class.to_s.underscore.tr('/', '_')
      end
    end
  end
end
