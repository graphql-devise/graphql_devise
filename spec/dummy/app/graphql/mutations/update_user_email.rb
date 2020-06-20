module Mutations
  class UpdateUserEmail < GraphQL::Schema::Mutation
    field :user, Types::UserType, null: false

    argument :email, String, required: true

    def resolve(email:)
      user = context[:current_resource]

      user.update!(email: email)

      { user: user }
    end
  end
end
