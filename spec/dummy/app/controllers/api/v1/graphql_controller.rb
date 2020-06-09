module Api
  module V1
    class GraphqlController < ApplicationController
      include GraphqlDevise::Concerns::SetUserByToken

      before_action -> { set_user_by_token(:user) }

      def graphql
        render json: DummySchema.execute(params[:query], context: { current_resource: @resource, controller: self })
      end

      def interpreter
        render json: InterpreterSchema.execute(params[:query], context: { current_resource: @resource, controller: self })
      end

      private

      def verify_authenticity_token
      end
    end
  end
end
