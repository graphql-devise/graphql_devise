module GraphqlDevise
  module Mutations
    class CheckPasswordToken < Base
      argument :reset_password_token, String, required: true
      argument :redirect_url,         String, required: false

      def resolve(reset_password_token:, redirect_url: nil)
        resource = resource_class.with_reset_password_token(reset_password_token)
        raise_user_error(I18n.t('graphql_devise.passwords.reset_token_not_found')) if resource.blank?

        if resource.reset_password_period_valid?
          token_info = client_and_token(resource.create_token)

          resource.skip_confirmation! if confirmable_enabled? && !resource.confirmed_at
          resource.allow_password_change = true if recoverable_enabled?

          resource.save!

          yield resource if block_given?

          redirect_header_options = { reset_password: true }
          redirect_headers = controller.send(
            :build_redirect_headers,
            token_info.fetch(:token),
            token_info.fetch(:client_id),
            redirect_header_options
          )

          if redirect_url.present?
            controller.redirect_to(resource.build_auth_url(redirect_url, redirect_headers))
          else
            set_auth_headers(resource)
          end

          { authenticable: resource }
        else
          raise_user_error(I18n.t('graphql_devise.passwords.reset_token_expired'))
        end
      end

      private

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
