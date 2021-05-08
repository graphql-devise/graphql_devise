# frozen_string_literal: true

module GraphqlDevise
  module Concerns
    module AdditionalControllerMethods
      extend ActiveSupport::Concern

      included do
        attr_accessor :client_id, :token, :resource
      end

      def gql_devise_context(*models)
        {
          current_resource: authenticate_model(*models),
          controller:       self
        }
      end

      def authenticate_model(*models)
        models.each do |model|
          set_resource_by_token(model)
          return @resource if @resource.present?
        end

        nil
      end

      def resource_class(resource = nil)
        # Return the resource class instead of looking for a Devise mapping if resource is already a resource class
        return resource if resource.respond_to?(:find_by)

        super
      end

      def full_url_without_params
        request.base_url + request.path
      end

      def set_resource_by_token(resource)
        set_user_by_token(resource)
      end

      def graphql_context(resource_name)
        ActiveSupport::Deprecation.warn(<<-DEPRECATION.strip_heredoc, caller)
          `graphql_context` is deprecated and will be removed in a future version of this gem.
           Use `gql_devise_context(model)` instead.

           EXAMPLE
           include GraphqlDevise::Concerns::SetUserByToken

           DummySchema.execute(params[:query], context: gql_devise_context(User))
           DummySchema.execute(params[:query], context: gql_devise_context(User, Admin))
        DEPRECATION

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
