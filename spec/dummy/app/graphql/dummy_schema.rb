# frozen_string_literal: true

class DummySchema < GraphQL::Schema
  use GraphqlDevise::SchemaPlugin.new(
    query:                Types::QueryType,
    mutation:             Types::MutationType,
    public_introspection: true,
    resource_loaders:     [
      GraphqlDevise::ResourceLoader.new(
        'User',
        only: [
          :login,
          :confirm_account,
          :send_password_reset,
          :resend_confirmation,
          :check_password_token
        ]
      ),
      GraphqlDevise::ResourceLoader.new('Guest', only: [:logout]),
      GraphqlDevise::ResourceLoader.new('SchemaUser')
    ]
  )

  mutation(Types::MutationType)
  query(Types::QueryType)
end
