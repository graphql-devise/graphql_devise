module GraphqlDevise
  module Mutations
    class Base < GraphQL::Schema::Mutation
      private

      def single_error_object(error)
        { success: false, errors: [error] }
      end

      def request
        context[:controller].request
      end

      def response
        context[:controller].response
      end

      def controller
        context[:controller]
      end

      def resource_class
        context[:resource_class]
      end
    end
  end
end
