# frozen_string_literal: true

require_relative 'option_sanitizers/array_checker'
require_relative 'option_sanitizers/hash_checker'
require_relative 'option_sanitizers/string_checker'
require_relative 'option_sanitizers/class_checker'

module GraphqlDevise
  module MountMethod
    SUPPORTED_OPTIONS = {
      at:                   OptionSanitizers::StringChecker.new('/graphql_auth'),
      operations:           OptionSanitizers::HashChecker.new([GraphQL::Schema::Resolver, GraphQL::Schema::Mutation]),
      only:                 OptionSanitizers::ArrayChecker.new(Symbol),
      skip:                 OptionSanitizers::ArrayChecker.new(Symbol),
      additional_queries:   OptionSanitizers::HashChecker.new(GraphQL::Schema::Resolver),
      additional_mutations: OptionSanitizers::HashChecker.new(GraphQL::Schema::Mutation),
      authenticatable_type: OptionSanitizers::ClassChecker.new(GraphQL::Schema::Member)
    }.freeze
  end
end
