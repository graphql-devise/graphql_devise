# frozen_string_literal: true

module Types
  class AdminType < GraphQL::Schema::Object
    field :id,    Int,    null: false
    field :email, String, null: false
  end
end
