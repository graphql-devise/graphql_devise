# frozen_string_literal: true

module Mutations
  class RegisterConfirmedUser < GraphqlDevise::Mutations::Base
    argument :email,                 String, required: true
    argument :name,                  String, required: true
    argument :password,              String, required: true
    argument :password_confirmation, String, required: true

    field :user, Types::UserType, null: true

    def resolve(**attrs)
      user = User.new(attrs.merge(confirmed_at: Time.zone.now))

      if user.save
        { user: user }
      else
        raise_user_error_list(
          'Custom registration failed',
          errors: user.errors.full_messages
        )
      end
    end
  end
end
