# frozen_string_literal: true

module Mutations
  class UpdateUser < BaseMutation
    field :user, Types::UserType, null: false

    argument :email, String, required: false
    argument :name,  String, required: false

    def resolve(**attrs)
      user = context[:current_resource]

      user.update_with_email(
        attrs.merge(confirmation_url: 'https://google.com')
      )

      { user: user }
    end
  end
end
