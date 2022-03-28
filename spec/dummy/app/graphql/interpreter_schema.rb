# frozen_string_literal: true

class InterpreterSchema < GraphQL::Schema
  if Gem::Version.new(GraphQL::VERSION) >= Gem::Version.new('1.9.0') && Gem::Version.new(GraphQL::VERSION) < Gem::Version.new('2.0')
    use GraphQL::Execution::Interpreter
  end
  if Gem::Version.new(GraphQL::VERSION) >= Gem::Version.new('1.10.0') && Gem::Version.new(GraphQL::VERSION) < Gem::Version.new('2.0')
    use GraphQL::Analysis::AST
  end

  use GraphqlDevise::SchemaPlugin.new(query: Types::QueryType, authenticate_default: false)

  mutation(Types::MutationType)
  query(Types::QueryType)
end
