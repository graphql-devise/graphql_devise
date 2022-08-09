# frozen_string_literal: true

module GraphqlDevise
  module ControllerMethods
    extend ActiveSupport::Concern

    private

    def check_redirect_url_whitelist!(redirect_url)
      if blacklisted_redirect_url?(redirect_url)
        raise_user_error(I18n.t('graphql_devise.redirect_url_not_allowed', redirect_url: redirect_url))
      end
    end

    def raise_user_error(message)
      raise UserError, message
    end

    def raise_user_error_list(message, errors:)
      raise DetailedUserError.new(message, errors: errors)
    end

    def remove_resource
      controller.resource = nil
      controller.client_id = nil
      controller.token = nil
    end

    def response
      controller.response
    end

    def controller
      context[:controller]
    end

    def resource_name
      ::GraphqlDevise.to_mapping_name(resource_class)
    end

    def resource_class
      self.class.instance_variable_get(:@resource_klass)
    end

    def recoverable_enabled?
      resource_class.devise_modules.include?(:recoverable)
    end

    def confirmable_enabled?
      resource_class.devise_modules.include?(:confirmable)
    end

    def blacklisted_redirect_url?(redirect_url)
      DeviseTokenAuth.redirect_whitelist && !DeviseTokenAuth::Url.whitelisted?(redirect_url)
    end

    def current_resource
      @current_resource ||= controller.send(:set_resource_by_token, resource_class)
    end

    def client
      if Gem::Version.new(DeviseTokenAuth::VERSION) <= Gem::Version.new('1.1.0')
        controller.client_id
      else
        controller.token.client if controller.token.present?
      end
    end

    def generate_auth_headers(resource)
      auth_headers = resource.create_new_auth_token
      controller.resource = resource
      access_token_name = DeviseTokenAuth.headers_names[:'access-token']
      client_name = DeviseTokenAuth.headers_names[:'client']

      # NOTE: Depending on the DTA version, the token will be an object or nil
      if controller.token
        controller.token.client = auth_headers[client_name]
        controller.token.token = auth_headers[access_token_name]
      else
        controller.client_id = auth_headers[client_name]
        controller.token = auth_headers[access_token_name]
      end

      auth_headers
    end

    def find_resource(field, value)
      if resource_class.connection.adapter_name.downcase.include?('mysql')
        # fix for mysql default case insensitivity
        resource_class.where("BINARY #{field} = ? AND provider= ?", value, provider).first
      elsif Gem::Version.new(DeviseTokenAuth::VERSION) < Gem::Version.new('1.1.0')
        resource_class.find_by(field => value, :provider => provider)
      else
        resource_class.dta_find_by(field => value, :provider => provider)
      end
    end

    def get_case_insensitive_field(field, value)
      if resource_class.case_insensitive_keys.include?(field)
        value.downcase
      else
        value
      end
    end

    def provider
      :email
    end
  end
end
