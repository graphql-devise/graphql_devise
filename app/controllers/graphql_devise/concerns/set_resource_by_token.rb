module GraphqlDevise
  module Concerns
    SetResourceByToken = DeviseTokenAuth::Concerns::SetUserByToken

    DeviseTokenAuth::Concerns::SetUserByToken.module_eval do
      attr_accessor :client_id, :token, :resource

      alias_method :set_resource_by_token, :set_user_by_token

      def graphql_context
        {
          current_resource: @resource,
          controller:       self
        }
      end

      def build_redirect_headers(access_token, client, redirect_header_options = {})
        {
          DeviseTokenAuth.headers_names[:"access-token"] => access_token,
          DeviseTokenAuth.headers_names[:client] => client,
          :config => params[:config],
          :client_id => client,
          :token => access_token
        }.merge(redirect_header_options)
      end
    end
  end
end
