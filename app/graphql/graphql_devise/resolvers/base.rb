require 'devise_token_auth/version'

module GraphqlDevise
  module Resolvers
    class Base < GraphQL::Schema::Resolver
      private

      def raise_user_error(message)
        raise GraphqlDevise::UserError, message
      end

      def raise_user_error_list(message, errors:)
        raise GraphqlDevise::DetailedUserError.new(message, errors: errors)
      end

      def request
        controller.request
      end

      def response
        controller.response
      end

      def controller
        context[:controller]
      end

      def resource_class
        context[:resource_class]
      end

      def confirmable_enabled?
        resource_class.devise_modules.include?(:confirmable)
      end

      def recoverable_enabled?
        resource_class.devise_modules.include?(:recoverable)
      end

      def current_resource
        context[:current_resource]
      end

      def set_auth_headers(resource)
        auth_headers = resource.create_new_auth_token
        response.headers.merge!(auth_headers)
      end

      def client
        if Gem::Version.new(DeviseTokenAuth::VERSION) <= Gem::Version.new('1.1.0')
          controller.client_id
        else
          controller.token.client if controller.token.present?
        end
      end
    end
  end
end
