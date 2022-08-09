# frozen_string_literal: true

module GraphqlDevise
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

    def set_resource_by_token(resource)
      set_user_by_token(resource)
    end

    def build_redirect_headers(access_token, client, redirect_header_options = {})
      {
        DeviseTokenAuth.headers_names[:'access-token'] => access_token,
        DeviseTokenAuth.headers_names[:client] => client,
        :config => params[:config],
        :client_id => client,
        :token => access_token
      }.merge(redirect_header_options)
    end
  end
end
