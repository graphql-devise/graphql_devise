module GraphqlDevise
  class ApplicationController < DeviseTokenAuth::ApplicationController
    private

    def verify_authenticity_token
    end
  end
end
