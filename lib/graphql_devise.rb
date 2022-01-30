# frozen_string_literal: true

require 'rails'
require 'rails/generators'
require 'graphql'
require 'devise_token_auth'
require 'zeitwerk'
require_relative '../app/models/graphql_devise/concerns/model'
require_relative '../app/models/graphql_devise/concerns/additional_model_methods'
require_relative 'graphql_devise/concerns/controller_methods'

GraphQL::Field.accepts_definitions(authenticate: GraphQL::Define.assign_metadata_key(:authenticate))
GraphQL::Schema::Field.accepts_definition(:authenticate)

loader = Zeitwerk::Loader.for_gem

controller_methods_concern = "#{__dir__}/graphql_devise/concerns/controller_methods.rb"
loader.ignore(controller_methods_concern)
loader.collapse("#{__dir__}/graphql_devise/errors")
loader.inflector.inflect('error_codes' => 'ERROR_CODES')
loader.inflector.inflect('supported_options' => 'SUPPORTED_OPTIONS')

loader.setup

ActionDispatch::Routing::Mapper.send(:include, GraphqlDevise::RoutesMounter)

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

  def self.resource_mounted?(model)
    @mounted_resources.include?(model)
  end

  def self.mount_resource(model)
    @mounted_resources << model
  end

  def self.add_mapping(mapping_name, resource)
    return if Devise.mappings.key?(mapping_name.to_sym)

    Devise.add_mapping(
      mapping_name.to_s.pluralize.to_sym,
      module: :devise, class_name: resource.to_s
    )
  end

  def self.to_mapping_name(resource)
    resource.to_s.underscore.tr('/', '_')
  end

  def self.configure_warden_serializer_for_model(model)
    Devise.warden_config.serialize_into_session(to_mapping_name(model)) do |record|
      model.serialize_into_session(record)
    end

    Devise.warden_config.serialize_from_session(to_mapping_name(model)) do |args|
      model.serialize_from_session(*args)
    end
  end
end

require 'graphql_devise/engine'
