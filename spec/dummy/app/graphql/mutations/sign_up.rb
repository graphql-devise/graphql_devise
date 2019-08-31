module Mutations
  class SignUp < GraphqlDevise::Mutations::SignUp
    field :user, Types::UserType, null: true

    def resolve(email:, **attrs)
      original_payload = super
      original_payload.merge(user: original_payload[:authenticable])
    end
  end
end
