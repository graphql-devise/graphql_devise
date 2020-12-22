# frozen_string_literal: true

module GraphqlDevise
  module Resolvers
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
          built_redirect_headers = redirect_headers(
            token_info,
            redirect_header_options
          )

          if redirect_url.present?
            check_redirect_url_whitelist!(redirect_url)
            controller.redirect_to(resource.build_auth_url(redirect_url, built_redirect_headers))
          else
            set_auth_headers(resource)
          end

          resource
        else
          raise_user_error(I18n.t('graphql_devise.passwords.reset_token_expired'))
        end
      end
    end
  end
end
