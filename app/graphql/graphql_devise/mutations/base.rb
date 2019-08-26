module GraphqlDevise
  module Mutations
    class Base < GraphQL::Schema::Mutation
      private

      def single_error_object(error)
        { success: false, errors: [error] }
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

      def token
        context[:token]
      end
    end
  end
end
