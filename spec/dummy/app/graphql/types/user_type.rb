# frozen_string_literal: true

module Types
  class UserType < GraphQL::Schema::Object
    field :id,            Int,    null: false
    field :email,         String, null: false
    field :name,          String, null: false
    field :sign_in_count, Int,    null: true
  end
end
