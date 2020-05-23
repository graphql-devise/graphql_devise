module Api
  module V1
    class GraphqlController < ApplicationController
      include GraphqlDevise::Concerns::SetUserByToken

      before_action :authenticate_user!

      def graphql
        render json: DummySchema.execute(params[:query])
      end

      private

      def verify_authenticity_token
      end
    end
  end
end
