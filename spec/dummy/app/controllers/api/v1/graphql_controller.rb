module Api
  module V1
    class GraphqlController < ApplicationController
      include GraphqlDevise::Concerns::SetUserByToken

      def graphql
        render json: DummySchema.execute(params[:query], context: graphql_context(:user))
      end

      def interpreter
        render json: InterpreterSchema.execute(params[:query], context: graphql_context(:user))
      end

      def failing_resource_name
        render json: DummySchema.execute(params[:query], context: graphql_context([:user, :fail]))
      end

      private

      def verify_authenticity_token
      end
    end
  end
end
