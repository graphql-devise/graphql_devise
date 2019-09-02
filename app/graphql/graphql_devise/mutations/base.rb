require 'devise_token_auth/version'

module GraphqlDevise
  module Mutations
    class Base < GraphQL::Schema::Mutation
      private

      def raise_user_error(message)
        raise GraphqlDevise::UserError, message
      end

      def remove_resource
        controller.resource = nil
        controller.client_id = nil
        controller.token = nil
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

      def current_resource
        context[:current_resource]
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
