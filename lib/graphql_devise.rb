# frozen_string_literal: true

require 'rails'
require 'graphql'
require 'devise_token_auth'

module GraphqlDevise
  class Error < StandardError; end

  class InvalidMountOptionsError < GraphqlDevise::Error; end

  @schema_loaded     = false
  @mounted_resources = []

  def self.schema_loaded?
    @schema_loaded
  end

  def self.load_schema
    @schema_loaded = true
  end

  def self.resource_mounted?(mapping_name)
    @mounted_resources.include?(mapping_name)
  end

  def self.mount_resource(mapping_name)
    @mounted_resources << mapping_name
  end

  def self.add_mapping(mapping_name, resource)
    return if Devise.mappings.key?(mapping_name.to_sym)

    Devise.add_mapping(
      mapping_name.to_s.pluralize.to_sym,
      module: :devise, class_name: resource
    )
  end

  def self.reconfigure_warden!
    Devise.class_variable_set(:@@warden_configured, nil)
    Devise.configure_warden!
  end

  def self.to_mapping_name(resource)
    resource.to_s.underscore.tr('/', '_')
  end
end

require 'graphql_devise/engine'
require 'graphql_devise/version'
require 'graphql_devise/errors/error_codes'
require 'graphql_devise/errors/execution_error'
require 'graphql_devise/errors/user_error'
require 'graphql_devise/errors/authentication_error'
require 'graphql_devise/errors/detailed_user_error'

require 'graphql_devise/concerns/controller_methods'
require 'graphql_devise/schema'
require 'graphql_devise/types/authenticatable_type'
require 'graphql_devise/types/credential_type'
require 'graphql_devise/types/mutation_type'
require 'graphql_devise/types/query_type'
require 'graphql_devise/default_operations/mutations'
require 'graphql_devise/default_operations/resolvers'
require 'graphql_devise/resolvers/dummy'

require 'graphql_devise/mount_method/option_sanitizer'
require 'graphql_devise/mount_method/options_validator'
require 'graphql_devise/mount_method/operation_preparer'
require 'graphql_devise/mount_method/operation_sanitizer'

require 'graphql_devise/resource_loader'
require 'graphql_devise/schema_plugin'
