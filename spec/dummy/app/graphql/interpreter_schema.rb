# frozen_string_literal: true

class InterpreterSchema < GraphQL::Schema
  use GraphQL::Execution::Interpreter if Gem::Version.new(GraphQL::VERSION) >= Gem::Version.new('1.9.0')
  use GraphQL::Analysis::AST          if Gem::Version.new(GraphQL::VERSION) >= Gem::Version.new('1.10.0')

  use GraphqlDevise::SchemaPlugin.new(query: Types::QueryType, authenticate_default: false)

  mutation(Types::MutationType)
  query(Types::QueryType)
end
