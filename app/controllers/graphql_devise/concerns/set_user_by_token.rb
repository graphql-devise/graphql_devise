module GraphqlDevise
  module Concerns
    SetUserByToken = DeviseTokenAuth::Concerns::SetUserByToken

    SetUserByToken.module_eval do
      attr_accessor :client_id, :token, :resource

      def full_url_without_params
        request.base_url + request.path
      end

      def set_resource_by_token(resource)
        set_user_by_token(resource)
      end

      def graphql_context(resource_name)
        {
          resource_name: resource_name,
          controller:    self
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
