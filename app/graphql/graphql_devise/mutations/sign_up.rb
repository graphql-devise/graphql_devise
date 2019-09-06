module GraphqlDevise
  module Mutations
    class SignUp < Base
      argument :email,                 String, required: true
      argument :password,              String, required: true
      argument :password_confirmation, String, required: true
      argument :confirm_success_url,   String, required: false
      argument :config_name,           String, required: false

      def resolve(confirm_success_url: nil, config_name: nil, **attrs)
        resource = resource_class.new(provider: provider, **attrs)

        if resource.present?
          resource.skip_confirmation_notification! if resource.respond_to?(:skip_confirmation_notification!)

          if resource.save
            yield resource if block_given?

            if requires_confirmation?(resource)
              resource.send_confirmation_instructions(
                client_config: config_name,
                redirect_url:  confirm_success_url
              )
            end

            set_auth_headers(resource) if resource.active_for_authentication?

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

      def requires_confirmation?(resource)
        resource.active_for_authentication? || !resource.confirmed?
      end

      def provider
        :email
      end

      def clean_up_passwords(resource)
        controller.send(:clean_up_passwords, resource)
      end
    end
  end
end
