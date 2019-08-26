module Types
  class UserType < GraphQL::Schema::Object
    field :email,         String, null: false
    field :name,          String, null: false
    field :sign_in_count, Int,    null: true
  end
end
