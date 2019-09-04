module GraphqlDevise
  module Mutations
    class SignUp < Base
      argument :email,                 String, required: true
      argument :name,                  String, required: false
      argument :password,              String, required: true
      argument :password_confirmation, String, required: true
      argument :confirm_success_url,   String, required: false
      argument :config_name,           String, required: false

      def resolve(email:, **attrs)
        redirect_url = attrs.delete(:confirm_success_url)
        resource     = resource_class.new(email: email, provider: :email, **attrs)

        if resource.present?
          resource.skip_confirmation_notification! if resource.respond_to?(:skip_confirmation_notification!)

          if resource.save
            yield resource if block_given?

            if confirmable_enabled?(resource) && !resource.confirmed?
              # user will require email authentication
              resource.send_confirmation_instructions(
                client_config: attrs[:config_name],
                redirect_url: redirect_url
              )
            end

            set_auth_headers(resource) if active_for_authentication?(resource)

            { authenticable: resource }
          else
            clean_up_passwords(resource)
            raise_user_error_list(
              I18n.t('graphql_devise.registration_failed'),
              errors: resource.errors.full_messages
            )
          end
        else
          raise_user_error(I18n.t('graphql_devise.resource_build_failed'))
        end
      end

      protected

      def confirmable_enabled?(resource)
        resource.respond_to?(:confirmed_at)
      end

      def active_for_authentication?(resource)
        resource.active_for_authentication?
      end

      def provider
        :email
      end

      # NOTE: Devise controller method, find a way to re use it
      def clean_up_passwords(resource)
        resource.clean_up_passwords if object.respond_to?(:clean_up_passwords)
      end
    end
  end
end
