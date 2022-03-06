# frozen_string_literal: true

module Api
  module V1
    class GraphqlController < ApplicationController
      include GraphqlDevise::SetUserByToken

      def graphql
        result = DummySchema.execute(params[:query], **execute_params(params))

        render json: result unless performed?
      end

      def interpreter
        render json: InterpreterSchema.execute(params[:query], **execute_params(params))
      end

      private

      def execute_params(item)
        {
          operation_name: item[:operationName],
          variables:      ensure_hash(item[:variables]),
          context:        gql_devise_context(SchemaUser, User)
        }
      end

      def ensure_hash(ambiguous_param)
        case ambiguous_param
        when String
          if ambiguous_param.present?
            ensure_hash(JSON.parse(ambiguous_param))
          else
            {}
          end
        when Hash, ActionController::Parameters
          ambiguous_param
        when nil
          {}
        else
          raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
        end
      end

      def verify_authenticity_token
      end
    end
  end
end
