# frozen_string_literal: true

module GraphqlDevise
  module Concerns
    SetUserByToken = DeviseTokenAuth::Concerns::SetUserByToken

    SetUserByToken.module_eval do
      attr_accessor :client_id, :token, :resource

      class_methods do
        def set_resource_by_model(models, **kwargs)
          Array(models).each do |model|
            GraphqlDevise.add_mapping(GraphqlDevise.to_mapping_name(model.to_s), model.to_s)
          end
          GraphqlDevise.reconfigure_warden!

          before_action(**kwargs) do
            authenticate_model(models)
          end
        end
      end

      def authenticate_model(models)
        Array(models).each do |model|
          set_resource_by_token(model)
          return @resource
        end

        nil
      end

      def resource_class(resource = nil)
        return super unless resource.is_a?(Class)

        if (Object.const_defined?('ActiveRecord::Base') && resource < ActiveRecord::Base) ||
           (Object.const_defined?('Mongoid::Document') && resource < Mongoid::Document)
          return resource
        end

        super
      end

      def full_url_without_params
        request.base_url + request.path
      end

      def set_resource_by_token(resource)
        set_user_by_token(resource)
      end

      def graphql_context(resource_name)
        context = {
          resource_name: resource_name,
          controller:    self
        }
        context[:current_resource] = @resource if @resource.present?

        context
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
