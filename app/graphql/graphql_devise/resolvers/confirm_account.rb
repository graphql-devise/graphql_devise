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
                token_and_client(controller.signed_in_resource.create_token),
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

      def redirect_headers(token_info, options)
        controller.send(
          :build_redirect_headers,
          token_info.fetch(:token),
          token_info.fetch(:client_id),
          options
        )
      end

      def client_and_token(token)
        if Gem::Version.new(DeviseTokenAuth::VERSION) <= Gem::Version.new('1.1.0')
          { client_id: token.first, token: token.last }
        else
          { client_id: token.client, token: token.token }
        end
      end
    end
  end
end
