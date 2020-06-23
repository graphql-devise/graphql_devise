# frozen_string_literal: true

module Mutations
  class UpdateUser < GraphQL::Schema::Mutation
    field :user, Types::UserType, null: false

    argument :email, String, required: false
    argument :name,  String, required: false

    def resolve(**attrs)
      user = context[:current_resource]

      schema_url = context[:controller].full_url_without_params

      user.update_with_email(
        attrs.merge(schema_url: schema_url, confirmation_success_url: 'https://google.com')
      )

      { user: user }
    end
  end
end
