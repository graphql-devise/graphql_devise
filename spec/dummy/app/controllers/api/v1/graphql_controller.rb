module Api
  module V1
    class GraphqlController < ApplicationController
      include GraphqlDevise::Concerns::SetUserByToken

      before_action :authenticate_user!

      def graphql
        render json: DummySchema.execute(params[:query])
      end
    end
  end
end
