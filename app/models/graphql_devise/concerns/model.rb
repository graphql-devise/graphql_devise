module GraphqlDevise
  module Concerns
    Model = DeviseTokenAuth::Concerns::User

    Model.module_eval do
      def send_devise_notification(notification, *args)
        if notification == :confirmation_instructions && DeviseTokenAuth.try(:send_confirmation_email) && try(:unconfirmed_email).present?
          options = args.last

          unless (options[:controller] && options[:action]) || DeviseTokenAuth.default_confirm_success_url
            raise GraphqlDevise::Error, 'You must set `default_confirm_success_url` on the DeviseTokenAuth initializer for reconfirmable to work.'
          end

          options[:template_path] = ['graphql_devise/mailer'] unless options.key?(:template_path)
        end

        super(notification, *args)
      end
    end
  end
end
